# frozen_string_literal: true

require_relative 'lib/phlex/style_variants/version'

Gem::Specification.new do |spec|
  spec.name = 'phlex-style_variants'
  spec.version = Phlex::StyleVariants::VERSION
  spec.authors = ['omarluq']
  spec.email = ['omar.luqman@hey.com']

  spec.summary = 'A powerful variant API for phlex components'
  spec.homepage = 'https://github.com/omarluq/phlex-style_variants'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/omarluq/phlex-style_variants/issues',
    'changelog_uri' => 'https://github.com/omarluq/phlex-style_variants/releases',
    'source_code_uri' => 'https://github.com/omarluq/phlex-style_variants',
    'homepage_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true',
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  # spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency 'literal', '~> 1.5'
end
