# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guideline/version'

Gem::Specification.new do |gem|
  gem.name          = "guideline"
  gem.version       = Guideline::VERSION
  gem.authors       = ["Ryo NAKAMURA"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = "Guideline.gem checks that your code is protecting" +
                      "the rule of coding guideline"
  gem.summary       = "The guideline of your code"
  gem.homepage      = "https://github.com/r7kamura/guideline"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "code_analyzer"
  gem.add_development_dependency "rspec", ">=2.12.0"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "simplecov"
end
