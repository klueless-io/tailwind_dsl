# frozen_string_literal: true

require_relative 'lib/tailwind_dsl/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version  = '>= 2.7'
  spec.name                   = 'tailwind_dsl'
  spec.version                = TailwindDsl::VERSION
  spec.authors                = ['David Cruwys']
  spec.email                  = ['david@ideasmen.com.au']

  spec.summary                = 'Tailwind DSL will build tailwind websites using Domain Specific Language conventions'
  spec.description            = <<-TEXT
    Tailwind DSL will build tailwind websites using Domain Specific Language conventions
  TEXT
  spec.homepage               = 'http://appydave.com/gems/tailwind_dsl'
  spec.license                = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri']           = spec.homepage
  spec.metadata['source_code_uri']        = 'https://github.com/klueless-io/tailwind_dsl'
  spec.metadata['changelog_uri']          = 'https://github.com/klueless-io/tailwind_dsl/commits/master'
  spec.metadata['documentation_uri']      = 'https://rubydoc.info/github/klueless-io/tailwind_dsl/master'

  # The `git ls-files -z` loads the RubyGem files that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
  # spec.extensions    = ['ext/tailwind_dsl/extconf.rb']

  spec.add_dependency 'cmdlet', '~> 0'
  # spec.add_dependency 'dry-initializer', '~> 0'
  spec.add_dependency 'gpt3-builder'
  spec.add_dependency 'k_log', '~> 0'
end
