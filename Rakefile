require 'bundler'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "queencheck"
    gemspec.summary = "like haskell's QuickCheck"
    gemspec.email = "rosylilly@aduca.org"
    gemspec.homepage = "https://github.com/rosylilly/QueenCheck"
    gemspec.description = "QueenCheck is random test library. Inspired by QuickCheck library in Haskell."
    gemspec.authors = ["Sho Kusano"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
