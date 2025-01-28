# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'phlex/style_variants'

require 'phlex/testing'

require 'minitest/autorun'
require 'minitest/reporters'
require 'nokogiri'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |rb| require(rb) }

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class Phlex::StyleVariants::Test < Minitest::Test
  include Phlex::Testing::Nokogiri
end
