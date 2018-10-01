# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_permalink/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_permalink'
  spec.version       = ActivePermalink::VERSION
  spec.authors       = ['Jonian Guveli']
  spec.email         = ['jonian@hardpixel.eu']
  spec.summary       = %q{Add permalinks to ActiveRecord models}
  spec.description   = %q{Add SEO friendly permalinks to ActiveRecord model with history support.}
  spec.homepage      = 'https://github.com/hardpixel/active-permalink'
  spec.license       = 'MIT'
  spec.files         = Dir['{lib/**/*,[A-Z]*}']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.0'
  spec.add_dependency 'active_delegate', '~> 1.0'
  spec.add_dependency 'babosa', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
