# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "queencheck"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sho Kusano"]
  s.date = "2012-02-17"
  s.description = "QueenCheck is random test library. Inspired by QuickCheck library in Haskell."
  s.email = "rosylilly@aduca.org"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".rvmrc",
    ".travis.yml",
    "Gemfile",
    "Guardfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/queencheck.rb",
    "lib/queencheck/arbitraries/all.rb",
    "lib/queencheck/arbitraries/boolean.rb",
    "lib/queencheck/arbitraries/integer.rb",
    "lib/queencheck/arbitraries/string.rb",
    "lib/queencheck/arbitrary.rb",
    "lib/queencheck/condition.rb",
    "lib/queencheck/core.rb",
    "lib/queencheck/exception.rb",
    "lib/queencheck/gen.rb",
    "lib/queencheck/result.rb",
    "queencheck.gemspec",
    "spec/queencheck/arbitrary_spec.rb",
    "spec/queencheck/core_spec.rb",
    "spec/queencheck/gen_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "https://github.com/rosylilly/QueenCheck"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "like haskell's QuickCheck"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2.2"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<fuubar>, [">= 0.0.6"])
      s.add_development_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_development_dependency(%q<growl>, [">= 1.0.3"])
      s.add_development_dependency(%q<spork>, [">= 0.9.0.rc9"])
      s.add_development_dependency(%q<rb-fsevent>, [">= 0.9.0"])
      s.add_development_dependency(%q<guard-spork>, [">= 0.5.1"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0.6.0"])
      s.add_development_dependency(%q<guard-bundler>, [">= 0.1.3"])
      s.add_development_dependency(%q<guard-yard>, [">= 1.0.2"])
      s.add_development_dependency(%q<yard>, [">= 0.7.4"])
      s.add_development_dependency(%q<yard-tomdoc>, [">= 0.3.0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<colorize>, [">= 0.5.8"])
      s.add_dependency(%q<rake>, [">= 0.9.2.2"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<fuubar>, [">= 0.0.6"])
      s.add_dependency(%q<jeweler>, [">= 1.8.3"])
      s.add_dependency(%q<growl>, [">= 1.0.3"])
      s.add_dependency(%q<spork>, [">= 0.9.0.rc9"])
      s.add_dependency(%q<rb-fsevent>, [">= 0.9.0"])
      s.add_dependency(%q<guard-spork>, [">= 0.5.1"])
      s.add_dependency(%q<guard-rspec>, [">= 0.6.0"])
      s.add_dependency(%q<guard-bundler>, [">= 0.1.3"])
      s.add_dependency(%q<guard-yard>, [">= 1.0.2"])
      s.add_dependency(%q<yard>, [">= 0.7.4"])
      s.add_dependency(%q<yard-tomdoc>, [">= 0.3.0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<colorize>, [">= 0.5.8"])
    s.add_dependency(%q<rake>, [">= 0.9.2.2"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<fuubar>, [">= 0.0.6"])
    s.add_dependency(%q<jeweler>, [">= 1.8.3"])
    s.add_dependency(%q<growl>, [">= 1.0.3"])
    s.add_dependency(%q<spork>, [">= 0.9.0.rc9"])
    s.add_dependency(%q<rb-fsevent>, [">= 0.9.0"])
    s.add_dependency(%q<guard-spork>, [">= 0.5.1"])
    s.add_dependency(%q<guard-rspec>, [">= 0.6.0"])
    s.add_dependency(%q<guard-bundler>, [">= 0.1.3"])
    s.add_dependency(%q<guard-yard>, [">= 1.0.2"])
    s.add_dependency(%q<yard>, [">= 0.7.4"])
    s.add_dependency(%q<yard-tomdoc>, [">= 0.3.0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end

