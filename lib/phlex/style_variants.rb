# lib/phlex/style_variants/style_variants.rb

# frozen_string_literal: true

require 'literal'
require 'debug'

module Phlex
  module StyleVariants
    autoload :VERSION, 'phlex/style_variants/version'
    autoload :Builder, 'phlex/style_variants/builder'
    autoload :VariantGroupBuilder, 'phlex/style_variants/variant_group_builder'
    autoload :Config, 'phlex/style_variants/config'
    autoload :Set, 'phlex/style_variants/set'
    autoload :StyleInstance, 'phlex/style_variants/style_instance'

    # Define ClassMethods for style definitions
    module ClassMethods
      # Define a new style set with optional inheritance
      # Usage:
      # style do
      #   base { "..." }
      #   variants do
      #     color do
      #       primary { "..." }
      #       danger { "..." }
      #     end
      #   end
      # end
      #
      # style(:wrapper, inherit: true) do
      #   base { "..." }
      #   variants do
      #     border { "..." }
      #   end
      # end

      def style_config
        @style_config ||= if superclass.respond_to?(:style_config)
          superclass.style_config.hard_copy
        else
          Config.new
        end
      end

      def style(name = default_style_name, &)
        style_config.define(name.to_sym, &)

        # After defining the style set, define enums and props
        style_set = style_config.styles[name.to_sym]
        style_set.__variants.each do |variant_group, options|
          # Define Enum Class for the Variant Group
          enum_class = Class.new(Literal::Enum) do
            prop :value, String
            options.each do |option_key, option_value|
              const_set(option_key.to_s.split('_').collect(&:capitalize).join, new(value: option_value))
            end
          end
          enum_const_name = "#{variant_group.to_s.split('_').collect(&:capitalize).join}Enum".freeze
          # Assign the Enum Class to the Component's Namespace
          const_set(enum_const_name, enum_class)

          # Define Props for the Variant Group
          # Set the first option as the default value
          default_variant = options.keys.first.to_s.capitalize
          prop variant_group.to_sym, enum_class, default: enum_class.const_get(default_variant), reader: :public
        end
      end

      # Helper method to remove module namespaces
      def demodulize(class_name)
        class_name.split('::').last
      end

      # Helper method to convert CamelCase to snake_case
      def underscore(camel_cased_word)
        word = camel_cased_word.dup
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!('-', '_')
        word.downcase!
        word
      end

      # Helper method to return the string if present, else nil
      def presence(string)
        (string.nil? || string.strip.empty?) ? nil : string
      end

      # Determine the default style name based on the class name
      def default_style_name
        @default_style_name ||= begin
          # Get the class name as a string
          class_name = name

          # Demodulize: Remove module namespaces
          base_name = demodulize(class_name)

          # Remove "Component" or "::Component" suffix
          base_name = base_name.sub(/Component$/, '')

          # Convert CamelCase to snake_case
          style_name = underscore(base_name)

          # Return the style_name if present; otherwise, default to 'component'
          presence(style_name) || 'component'
        end
      end
    end

    # Define InstanceMethods for style compilation
    module InstanceMethods
      # Compile styles based on provided variants
      # Usage:
      # style(color: :primary, size: :md).size.md? # => true
      def style(name = self.class.default_style_name, **variants)
        compiled = self.class.style_config.compile(name.to_sym, **variants).strip
        StyleInstance.new(compiled:, variants:)
      end
    end

    # Hook to include ClassMethods and InstanceMethods when included
    def self.included(base)
      base.extend(ClassMethods)
      base.extend(Literal::Properties)
      base.include(InstanceMethods)
    end
  end
end
