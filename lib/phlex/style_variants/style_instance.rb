# frozen_string_literal: true

# lib/phlex/style_variants/instance.rb

module Phlex
  module StyleVariants
    # Represents the compiled classes and variant enums
    class StyleInstance < Literal::Struct
      prop :compiled, String
      prop :variants, _Hash(_Symbol, Literal::Enum), default: -> { {} }

      # Delegate variant predicate methods (e.g., size.md?) to the enums
      def method_missing(name, *args, &block)
        if @variants.key?(name.to_sym) && @enums.key?(name.to_sym)
          @variants[name.to_sym].__send__("#{variants[name.to_sym]}?")
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        @variants.key?(name.to_sym) || super
      end
    end
  end
end
