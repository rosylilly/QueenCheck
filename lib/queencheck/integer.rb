require 'queencheck/arbitrary'

class Integer
  extend QueenCheck::Arbitrary

  @@bound = 25

  set_arbitrary do |seed|
    if seed == 0
      0
    else
      max = 10 ** ((@@bound * seed).ceil)
      rand(max) * (rand(2).zero? ? 1 : -1)
    end
  end
end
