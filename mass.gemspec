# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mass/version'

Gem::Specification.new do |spec|
  spec.name          = 'mass'
  spec.version       = Mass::VERSION
  spec.authors       = ['Tom Scott']
  spec.email         = ['tscott@weblinc.com']

  spec.summary       = 'Synth framework for Ruby.'
  spec.description   = "#{spec.summary} Build a cool synth!"
  spec.homepage      = 'https://github.com/tubbo/mass'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(spec)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'travis', '~> 1.8'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0'
  spec.add_development_dependency 'pry', '~> 0'

  spec.add_dependency 'unimidi', '~> 0'
end
