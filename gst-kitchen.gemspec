# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gst-kitchen/version'

Gem::Specification.new do |gem|
  gem.name          = "gst-kitchen"
  gem.version       = GstKitchen::VERSION
  gem.authors       = ["Sebastian Cohnen"]
  gem.email         = ["sebastian.cohnen@gmx.net"]
  gem.description   = %q{gst-kitchen is a gem to publish podcasts like a nerd with auphonic!}
  gem.summary       = %q{gst-kitchen is a gem to publish podcasts like a nerd with auphonic!}
  gem.homepage      = "http://github.com/tisba/gst-kitchen"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "yajl-ruby"
  gem.add_dependency "trollop"
  gem.add_dependency "rake"
  gem.add_dependency "redcarpet"
end
