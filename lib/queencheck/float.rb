require 'queencheck/arbitrary'

class Float
  extend QueenCheck::Arbitrary

  @@bound = 25

  set_arbitrary do |seed|
    if seed == 0
      0.0
    else
      if seed > 0.9 && rand(3) > 0
        return rand(2).zero? ? 0.0/0.0 : rand(2).zero? ? 1.0/0 : -1.0/0
      end
      base = ((@@bound * seed).ceil).to_f
      max = 10.0 ** base
      num = rand(max)
      nod = num.to_s.length
      num.to_f / (10 ** ((rand(nod / 2) + nod / 2) / 2)) * (rand(2).zero? ? 1.0 : -1.0)
    end
  end
end

