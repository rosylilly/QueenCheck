require 'rubygems'
require 'spork'
require 'rspec'

Spork.prefork do
  config(:before) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end
end

Spork.each_run do
end
