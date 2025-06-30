# frozen_string_literal: true

require_relative "lib/mri_hook/version"

Gem::Specification.new do |spec|
  spec.name = "mri_hook"
  spec.version = MriHook::VERSION
  spec.authors = ["Enrique Gutierrez (Chucheen)"]
  spec.email = ["jegut87@gmail.com"]

  spec.summary = "MRI Software API Client for Gran Ciudad"
  spec.description = "This gem provides a client interface to interact with MRI Software's API, specifically designed for Gran Ciudad's internal platforms (Catatumbo and Pandora) integration with their ERP system."
  spec.homepage = "https://mica.rent"
  spec.required_ruby_version = ">= 3.0.0"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/MicaTechnology/mri_hook"
  spec.metadata["changelog_uri"] = "https://github.com/MicaTechnology/mri_hook/blob/main/CHANGELOG.md"

  # Runtime dependencies
  spec.add_runtime_dependency 'rest-client', '~> 2.1'
  spec.add_runtime_dependency 'activesupport', '>= 6.1'

  # Development dependencies
  spec.add_development_dependency "ffaker", "~> 2.21"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'webmock', '~> 3.18'
  spec.add_development_dependency 'rubocop', '~> 1.21'

  # File handling
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
