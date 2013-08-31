# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telepath/version'

Gem::Specification.new do |spec|
  spec.name          = 'telepath'
  spec.version       = Telepath::VERSION
  spec.authors       = ['Anthony Cook']
  spec.email         = ['anthonymichaelcook@gmail.com']
  spec.description   = %q{Sorta like IPC for people to GTD.}
  spec.summary       = %q{Spooky action at a distance.}
  spec.homepage      = 'http://github.com/acook/telepath#readme'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
