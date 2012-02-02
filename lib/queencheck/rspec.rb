
begin
  require 'queencheck'
rescue LoadError
  require "pathname"
  $:.unshift Pathname.new(File.expand_path('../../', __FILE__))
  require 'queencheck'
end

require 'rspec'
require 'queencheck/rspec/dsl'
