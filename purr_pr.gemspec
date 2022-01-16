# frozen_string_literal: true

require_relative 'lib/purr_pr/version'

Gem::Specification.new do |spec|
  spec.name        = 'purr-pr'
  spec.version     = PurrPr::VERSION
  spec.author      = 'Alexander Teslovskiy'
  spec.email       = 'artoriousso@gmail.com'
  spec.summary     = 'A CLI pull request formatter'
  spec.description = 'Purr PR is a tool to automate pull request formatting via GitHub CLI'
  spec.homepage    = 'https://github.com/ARtoriouSs/purr-pr'
  spec.license     = 'MIT'

  spec.metadata = {
    'documentation_uri' => 'https://github.com/ARtoriouSs/purr-pr/blob/master/README.md',
    'bug_tracker_uri'   => 'https://github.com/ARtoriouSs/purr-pr/issues',
    'source_code_uri'   => 'https://github.com/ARtoriouSs/purr-pr',
    'changelog_uri'     => 'https://github.com/ARtoriouSs/purr-pr/blob/master/CHANGELOG.md',
    'wiki_uri'          => 'https://github.com/ARtoriouSs/purr-pr/wiki',
    'homepage_uri'      => 'https://github.com/ARtoriouSs/purr-pr'
  }

  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   << 'purr'

  spec.files         = `git ls-files -z`.split("\x0").reject { |file| file.match(%r{^spec/}) }
  spec.test_files    = `git ls-files -- spec`.split("\n")

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
