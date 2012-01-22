require 'rubygems'
require 'spork'
require 'rspec'

Spork.prefork do
  $:.unshift Pathname.new(File.expand_path('../../lib/', __FILE__))
end

Spork.each_run do
end
