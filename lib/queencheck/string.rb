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
      charset = (0x61 ... 0x7a).to_a + (0x41 ... 0x5a).to_a
    elsif seed < 0.3 # ASCII
      charset = (0x32 ... 0x7e).to_a
    elsif seed < 0.5
      charset = (0x00 ... 0x7f).to_a
    elsif seed < 0.7
      charset = (0x00 ... 0x7f).to_a
      charset += (0x80 ... 0x7ff).to_a
    elsif seed < 0.9
      charset = (0x00 ... 0x7f).to_a
      charset += (0x80 ... 0x7ff).to_a
      charset += (0x800 ... 0x7fff).to_a
    elsif seed < 1
      charset = (0x00 ... 0x7f).to_a
      charset += (0x80 ... 0x7ff).to_a
      charset += (0x800 ... 0x7fff).to_a
      charset += (0x1000 ... 0x1ffff).to_a
    end

    ret = []
    (rand(max/2) + (max/2)).times do
      ret << charset[rand(charset.length)]
    end

    return ret.pack('U*')
  end
end
