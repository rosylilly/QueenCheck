require 'rubygems'
require 'spork'
require 'rspec'

Spork.prefork do
end

Spork.each_run do
  Dir::glob('./lib/**/*.rb'){|f| load f }
end
