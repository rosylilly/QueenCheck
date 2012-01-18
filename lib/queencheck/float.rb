require 'queencheck/arbitrary'

class Float
  extend QueenCheck::Arbitrary

  @@bound = 50

  set_arbitrary do |seed|
    if seed == 0
      0.0
    else
      if seed > 0.9 && rand(3) > 0
        return rand(2).zero? ? 0.0/0.0 : rand(2).zero? ? 1.0/0 : -1.0/0
      end
      base = ((@@bound * seed).ceil).to_f
      max = 10.0 ** base
      rand(max).to_f / (10.0 ** (base/2.0)) * (rand(2).zero? ? 1.0 : -1.0)
    end
  end
end

