# QueenCheck is Test Utility Library like Quick Check in Haskell.
#
# == Examples:
# 
#     QueenCheck(Integer, Integer) do | x, y |
#       x + y == y + x
#     end
module QueenCheck
  VERSION = '1.0.0'
end

$: << File.dirname(File.expand_path(__FILE__))
require 'queencheck/core'
require 'queencheck/arbitrary'
require 'queencheck/gen'
require 'queencheck/condition'
require 'queencheck/exception'

require 'queencheck/arbitraries/all'
