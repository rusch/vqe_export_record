$:.push File.expand_path("../lib", __FILE__)
require 'vqe_export_record/version'

Gem::Specification.new do |s|
  s.name = %q{vqe_export_record}
  s.version = VqeExportRecord::VERSION
  s.author = "Christian Rusch"

  s.description = %q{This gem allows either parsing VQE Export Record Packets
or reading packets from a stream into Ruby Objects, making it easy to read
and work with the encapsulated data.}

  s.email = %{git@rusch.asia}
  s.extra_rdoc_files = Dir.glob("*.rdoc")
  s.files = Dir.glob("{lib,spec}/**/*") + Dir.glob("*.rdoc") +
    %w(Gemfile Rakefile vqe_export_record.gemspec)
  s.homepage = %{http://github.com/rusch/vqe_export_record}
  s.licenses = %w(MIT)
  s.rubygems_version = %q{1.5.2}
  s.summary = %{Parse and create VQE Export Record Packets and Streams}
  s.test_files = Dir.glob("spec/**/*")

  s.add_development_dependency 'bundler', "> 1.0.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', ">= 2.6.0"
  s.add_development_dependency 'simplecov', ">= 0.5.0"
end
