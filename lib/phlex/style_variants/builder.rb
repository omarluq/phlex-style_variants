# frozen_string_literal: true

# lib/phlex/style_variants/builder.rb

module Phlex
  module StyleVariants
    class Builder
      def build(&)
        @variants = {}
        instance_eval(&) if block_given?
        @variants
      end

      def method_missing(name, &)
        group = VariantGroupBuilder.new(name)
        group.instance_eval(&) if block_given?
        @variants[name.to_sym] = group.options
      end

      def respond_to_missing?(name, include_private = false)
        true
      end
    end
  end
end
