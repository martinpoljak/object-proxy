# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "object-proxy"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Koz\u{e1}k"]
  s.date = "2011-10-19"
  s.email = "martinkozak@martinkozak.net"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/object-proxy.rb",
    "object-proxy.gemspec",
    "test"
  ]
  s.homepage = "http://github.com/martinkozak/object-proxy"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Provides collection of four proxy objects intended for intercepting calls to instance methods. Works as intermediate layer between caller and called. Allows to invoke an handler both before method call and adjust its arguments and after call and post-proccess result. Aimed as tool for instant adapting the complex objects without complete deriving and extending whole classes in cases, where isn't possible to derive them as homogenic functional units or where it's simply impractical to derive them."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hash-utils>, [">= 0.12.1"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_development_dependency(%q<riot>, [">= 0.12.1"])
    else
      s.add_dependency(%q<hash-utils>, [">= 0.12.1"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 1.5.2"])
      s.add_dependency(%q<riot>, [">= 0.12.1"])
    end
  else
    s.add_dependency(%q<hash-utils>, [">= 0.12.1"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 1.5.2"])
    s.add_dependency(%q<riot>, [">= 0.12.1"])
  end
end

