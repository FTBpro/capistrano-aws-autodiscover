# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-aws-autodiscover/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-aws-autodiscover"
  spec.version       = CapistranoAwsAutodiscover::VERSION
  spec.authors       = ["Erez Rabih"]
  spec.email         = ["techutil@minutemedia.com"]
  spec.summary       = %q{Automatically defines servers in your capistrano deploy script}
  spec.description   = %q{Tired of changing dns names or ips in your deploy.rb? You found a solution! This gem uses EC2 tags in order to define servers in your deploy script. You can set project, environment and roles tags per instance to have total control.}

  spec.homepage      = "https://github.com/FTBpro/capistrano-aws-autodiscover"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '10.1.1'
  spec.add_runtime_dependency     "aws-sdk-core", '2.7.11'
  
end
