# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = 'fluent-plugin-bind'
  spec.version = '0.1.0'
  spec.authors = ['Thomas Tych']
  spec.email   = ['thomas.tych@gmail.com']

  spec.summary       = 'fluentd plugin for bind log format.'
  spec.homepage      = 'https://github.com/ttych/fluent-plugin-bind'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  test_files, files = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'flay', '~> 2.12', '>= 2.12.1'
  spec.add_development_dependency 'flog', '~> 4.6', '>= 4.6.4'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'reek', '~> 6.0', '>= 6.0.3'
  spec.add_development_dependency 'rubocop', '~> 1.11'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.1'
  spec.add_development_dependency 'test-unit', '~> 3.4'

  spec.add_runtime_dependency 'fluentd', ['>= 0.14.10', '< 2']
end
