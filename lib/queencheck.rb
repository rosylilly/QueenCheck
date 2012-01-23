require "pathname"
$:.unshift Pathname.new(File.expand_path('../', __FILE__))

require 'queencheck/core'
require 'queencheck/arbitrary'

require 'queencheck/integer'
require 'queencheck/float'
require 'queencheck/boolean'
require 'queencheck/array'
require 'queencheck/string'

module QueenCheck
  unless defined? Version
    Version = `cat #{Pathname.new(File.expand_path('../../', __FILE__))}/VERSION`.strip
  end
end
