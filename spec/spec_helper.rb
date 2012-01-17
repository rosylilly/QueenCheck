require 'rubygems'
require 'spork'

Spork.prefork do
  require 'rspec/autorun'
  require 'autotest/rspec2'
  require 'queencheck'
end

Spork.each_run do
end
