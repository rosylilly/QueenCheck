require 'bundler'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

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

begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['--plugin=yard-tomdoc']
    t.options << '--debug' << '--verbose' if $trace
  end
rescue LoadError
  puts "YARD not available. Install it with: bundle install"
end

begin
  require 'pry'

  task "pry" do
    require './lib/queencheck'
    binding.pry
  end
rescue LoadError
  puts "Pry not available. Install it with: gem intall pry"
end
