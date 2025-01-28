# frozen_string_literal: true

# lib/phlex/style_variants/config.rb

module Phlex
  module StyleVariants
    # Configuration class to hold multiple style sets
    class Config < Literal::Struct
      prop :styles, _Hash(_Symbol, Set), default: -> { {} }

      # Define a new style set
      def define(name, &)
        styles[name.to_sym] = Set.new
        styles[name.to_sym].instance_eval(&)
      end

      # Compile a style by name and variants
      def compile(name, **variants)
        style_set = styles[name.to_sym]
        return '' unless style_set

        style_set.compile(**variants)
      end

      # Create a hard copy of the config, duplicating each style set
      def hard_copy
        copied_styles = styles.transform_values(&:dup)
        self.class.new(styles: copied_styles)
      end
    end
  end
end
