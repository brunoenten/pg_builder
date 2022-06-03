# frozen_string_literal: true

require_relative "lib/pg_builder/version"

Gem::Specification.new do |spec|
  spec.name = "pg_builder"
  spec.version = PgBuilder::VERSION
  spec.authors = ["Bruno Enten"]
  spec.email = ["bruno@proluceo.com"]

  spec.summary = "Postgresql schema builder"
  spec.description = "Allows splitting a Postgresql schema into individual files for each object (table, function, ...) then build the schema, with generated tests."
  spec.homepage = "https://github.com/brunoenten/pg_builder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + '/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "cucumber", "~> 7.0"
  spec.add_dependency "pg", "~> 1.2"
  spec.add_dependency "docker-api", "~> 2.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
