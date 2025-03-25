# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "table_format/version"

Gem::Specification.new do |spec|
  spec.name         = "table_format"
  spec.version      = TableFormat::VERSION
  spec.author       = "akicho8"
  spec.email        = "akicho8@gmail.com"
  spec.homepage     = "https://github.com/akicho8/table_format"
  spec.summary      = "TableFormat shows text table like emacs org-table for easy reading."
  spec.description  = "TableFormat shows text table like emacs org-table for easy reading."
  spec.platform     = Gem::Platform::RUBY

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.rdoc_options  = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  spec.add_dependency "activesupport"
  spec.add_dependency "nkf"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "ostruct"
end
