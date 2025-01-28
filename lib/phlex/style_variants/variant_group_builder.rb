# frozen_string_literal: true

module Phlex
  module StyleVariants
    # Helper class to build individual variants within a group
    class VariantGroupBuilder
      attr_reader :options

      def initialize(name)
        @name = name
        @options = {}
      end

      def method_missing(option_name, &)
        @options[option_name.to_sym] = instance_eval(&)
      end

      def respond_to_missing?(name, include_private = false)
        true
      end
    end
  end
end
