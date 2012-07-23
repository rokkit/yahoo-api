# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yahoo-api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Whinfrey"]
  gem.email         = ["james@conceptric.co.uk"]
  gem.description   = %q{Wrapper for the YQL used to query Yahoo! APIs}
  gem.summary       = %q{A library to simplify the construction and use of Yahoo! API queries made using the Yahoo! Query Language}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yahoo-api"
  gem.require_paths = ["lib"]
  gem.version       = Yahoo::Api::VERSION

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('vcr')
  gem.add_development_dependency('webmock')
  gem.add_dependency('rake')
  gem.add_dependency('json')  
end
