require 'rubygems'
require 'spork'
require 'rspec'

Spork.prefork do
  Rspec.configure do | config |
    config(:before) do
      @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
    end
  end
end

Spork.each_run do
end
