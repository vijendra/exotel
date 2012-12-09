# -*- encoding: utf-8 -*-
require File.expand_path("../lib/exotel/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "exotel"
  s.version     = Exotel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Vijendra Rao']
  s.email       = ['vijendrakarkala@gmail.com']
  s.homepage    = %q{https://github.com/vijendra/exotel}
  s.summary     = "Wrapper for exotel api"
  s.description = "Exotel api wrapper."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "exotel"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "webmock"
  
  s.add_dependency 'httparty', '>= 0.9.0'
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
