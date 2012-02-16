require 'queencheck/arbitrary'

class Char
  arbitrary QueenCheck::Gen.choose(0, 127).bind { | c |
    QueenCheck::Gen.unit(c.chr)
  }
end

class String
  arbitrary QueenCheck::Gen.quadratic(20000).bind { | length |
    QueenCheck::Gen.rand.resize(0, length).bind { | r |
      str = []
      r.times { str << Char.arbitrary.gen.value(0) }
      QueenCheck::Gen.unit(str.join())
    }
  }
end
