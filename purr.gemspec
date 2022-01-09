# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'purr/version'

require_relative "lib/purr/version"

Gem::Specification.new do |spec|
  spec.name        = 'purr-pr'
  spec.version     = Purr::VERSION
  spec.author      = 'Alexander Teslovskiy'
  spec.email       = 'artoriousso@gmail.com'
  spec.summary     = ''
  spec.description = ''
  spec.homepage    = 'https://github.com/ARtoriouSs/purr'
  spec.license     = 'MIT'

  spec.metadata = {
    'documentation_uri' => 'https://github.com/ARtoriouSs/purr/blob/master/README.md',
    'bug_tracker_uri'   => 'https://github.com/ARtoriouSs/purr/issues',
    'source_code_uri'   => 'https://github.com/ARtoriouSs/purr',
    'changelog_uri'     => 'https://github.com/ARtoriouSs/purr/blob/master/CHANGELOG.md',
    'wiki_uri'          => 'https://github.com/ARtoriouSs/purr/wiki',
    'homepage_uri'      => 'https://github.com/ARtoriouSs/purr'
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
