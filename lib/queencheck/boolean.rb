require 'queencheck/arbitrary'

class Boolean
  extend QueenCheck::Arbitrary

  set_arbitrary do | seed |
    rand(2).zero? ? true : false
  end
end
