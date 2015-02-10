# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socials/version'

Gem::Specification.new do |spec|
  spec.name          = "socials"
  spec.version       = Socials::VERSION
  spec.authors       = ["Ilton Garcia dos Santos Silveira"]
  spec.email         = ["ilton_unb@hotmail.com"]

  spec.summary       = 'Simple OAuth SocialNetworks consumer'
  spec.description   = 'It is the easiest way to consume OAuth 2.0 in any Ruby based server like Rails &/or Sinatra'
  spec.homepage      = "http://tonfw.github.io/socials"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #================== GEMs to build it GEM, so its improve the development ==============================
  # Base GEMs to build it gem
  spec.add_development_dependency 'bundler', '~> 1.7', '>= 1.7.12'
  spec.add_development_dependency "rake", "~> 10.3", '>= 10.3.2'

  # RSpec for tests
  spec.add_development_dependency "rspec", "~> 3.1", '>= 3.1.0'
  # Coverage
  spec.add_development_dependency 'simplecov', '~> 0.7', '>= 0.7.1'
  # Create readable attrs values
  spec.add_development_dependency 'faker', '~> 1.4', '>= 1.4.2'

  #================== GEMs to be used when it is called on a project ====================================
  # For real user operator IP (4GeoLoc)
  spec.add_dependency 'curb', "~> 0.8", '>= 0.8.6'
  # HTTP REST Client
  spec.add_dependency "rest-client", '~> 1.7', '>= 1.7.2'
  # Easy JSON create
  spec.add_dependency "multi_json", '~> 1.10', '>= 1.10.1'
  # To pretty print on console
  spec.add_dependency "colorize", '~> 0.7.3', '>= 0.7.3'
  # To create the ShareLinks, to be DRY
  spec.add_dependency "just_share", '~> 1.0.4', '>= 1.0.4'
end
