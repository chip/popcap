# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'pop_cap'

Gem::Specification.new do |s|
  s.name        = 'pop_cap'
  s.version     = PopCap::VERSION
  s.authors     = ["Culley Smith"]
  s.email       = ["culley.smith@gmail.com"]
  s.homepage    = %q{http://madstance.com}
  s.summary     = %q{A library work with audio files on the filesystem .}
  s.description = %q{Read & write metadata tags, convert audio files to alternate formats, manage files on the filesystem.}

  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'reek', '~> 1.2'
  s.add_development_dependency 'rspec', '~> 2.11'
  s.add_development_dependency 'simplecov', '~> 0.7'

  git_files            = `git ls-files -z`.split("\0") rescue ''
  s.files              = git_files
  s.test_files         = `git ls-files -z -- {test,spec,features}/*`.split("\0")
  s.require_paths      = ['lib']
end
