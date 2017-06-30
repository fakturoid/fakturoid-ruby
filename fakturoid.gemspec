# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fakturoid/version'

Gem::Specification.new do |s|
  s.name          = "fakturoid"
  s.version       = Fakturoid::VERSION
  s.authors       = ["Eda Riedl", "Lukáš Konarovský"]
  s.email         = ["podpora@fakturoid.cz"]
  s.summary       = %q{Ruby client for web based invoicing service www.fakturoid.cz}
  s.description   = %q{Ruby client for web based invoicing service www.fakturoid.cz}
  s.homepage      = "https://github.com/fakturoid/fakturoid-ruby"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'multi_json'
  s.add_dependency 'faraday'

  s.add_development_dependency "bundler", "> 1"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "shoulda-context"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rubocop"
end
