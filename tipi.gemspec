lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tipi/version'

Gem::Specification.new do |spec|
  spec.name          = 'tipi'
  spec.version       = Tipi::VERSION::String
  spec.authors       = ['Andrey Savchenko']
  spec.email         = ['andrey@aejis.eu']
  spec.summary       = %q{OO HTTP primitives}
  spec.description   = %q{OO HTTP primitives}
  spec.homepage      = 'https://github.com/Ptico/tipi'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'
end
