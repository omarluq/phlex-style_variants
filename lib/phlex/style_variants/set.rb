# frozen_string_literal: true

# lib/phlex/style_variants/set.rb

module Phlex
  module StyleVariants
    # Represents a set of styles with base and variants
    class Set < Literal::Struct
      # Make 'base' _Nilable and default to nil
      prop :__base, _Nilable(String), default: -> {}
      prop :__variants, _Hash(_Symbol, _Hash(_Symbol, String)), default: -> { {} }

      # Define base styles
      def base(&)
        self.__base = instance_eval(&)
      end

      # Define variants using the Builder DSL
      def variants(&)
        builder = Builder.new
        self.__variants = builder.build(&)
      end

      # Compile the class string based on variants
      def compile(**opts)
        classes = __base ? __base.dup : ''

        opts.each do |variant_group, variant_value|
          classes += " #{variant_value.value}"
        end

        classes.strip
      end
    end
  end
end
