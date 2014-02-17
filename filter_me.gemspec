# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'filter_me/version'

Gem::Specification.new do |s|
	s.name        = 'filter_me'
	s.version     = FilterMe::VERSION
	s.authors     = ['Sam Clopton']
	s.email       = ['samsinite@gmail.com']
	s.homepage    = 'https://github.com/samsinite/filter_me'
	s.summary     = 'Filter Me'
	s.description = 'This friendly library gives you ActiveRecord/Arel filtering in your Rails app.'
	s.license     = 'MIT'

	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {spec}/*`.split("\n")
	s.require_paths = ['lib']

	s.add_runtime_dependency     'activerecord', '>= 3.2.0'
	s.add_runtime_dependency     'activesupport', '>= 3.2.0'
	s.add_development_dependency 'combustion',   '~> 0.5.1'
	s.add_development_dependency 'rspec-rails',  '~> 2.13'
	s.add_development_dependency 'sqlite3',      '~> 1.3.7'
end
