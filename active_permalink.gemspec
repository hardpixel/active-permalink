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
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0', '< 8'
  spec.add_dependency 'active_delegate', '>= 1.0'
  spec.add_dependency 'any_ascii', '>= 0.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
