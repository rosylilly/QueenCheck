require 'queencheck/arbitrary'

class String
  extend QueenCheck::Arbitrary

  @@max_length = 3000

  set_arbitrary do | seed |
    max = (@@max_length * (seed * seed)).ceil

    charset = []
    if seed == 0
      return ''
    elsif seed < 0.1
      charset = (0x61 ... 0x7b).to_a + (0x41 ... 0x5b).to_a
    elsif seed < 0.3 # ASCII
      charset = (0x32 ... 0x7f).to_a
    elsif seed < 0.5
      charset = (0x00 ... 0x80).to_a
    elsif seed < 0.7
      charset = (0x00 ... 0x80).to_a
      charset += (0x80 ... 0x800).to_a
    elsif seed < 0.9
      charset = (0x00 ... 0x80).to_a
      charset += (0x80 ... 0x800).to_a
      charset += (0x800 ... 0x8000).to_a
    elsif seed <= 1
      charset = (0x00 ... 0x80).to_a
      charset += (0x80 ... 0x800).to_a
      charset += (0x800 ... 0x8000).to_a
      charset += (0x1000 ... 0x20000).to_a
    end

    ret = []
    (rand(max/2) + (max/2)).times do
      ret << charset.sample
    end

    return ret.pack('U*')
  end
end
