require 'queencheck/arbitrary'

class Integer
  arbitrary QueenCheck::Gen.quadratic(1<<20).bind { |n|
    QueenCheck::Gen.rand.resize(-(n.ceil), n.ceil)
  }
end

class Fixnum
  arbitrary Integer.arbitrary.gen
end

class Bignum
  arbitrary QueenCheck::Gen.quadratic(1<<20, 1, (1 << (0.size * 8))).bind {|n|
    QueenCheck::Gen.rand.resize(-(n.ceil), n.ceil)
  }
end
