# frozen_string_literal: true

require_relative "lib/fakturoid/version"

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = "fakturoid"
  spec.version       = Fakturoid::VERSION
  spec.authors       = ["Eda Riedl", "Lukáš Konarovský", "Oldřich Vetešník", "Kamil Hanus"]
  spec.email         = ["podpora@fakturoid.cz"]

  spec.summary       = "Ruby client for web based invoicing service www.fakturoid.cz"
  spec.description   = "Ruby client for web based invoicing service www.fakturoid.cz"
  spec.homepage      = "https://github.com/fakturoid/fakturoid-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0" # rubocop:disable Gemspec/RequiredRubyVersion

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fakturoid/fakturoid-ruby"
  spec.metadata["changelog_uri"]   = "https://github.com/fakturoid/fakturoid-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "multi_json"

  spec.add_development_dependency "bundler", "> 1"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "shoulda-context"
end
