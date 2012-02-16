require 'queencheck/arbitrary'

module QueenCheck
  class ASCIIChar
    arbitrary QueenCheck::Gen.choose(0, 127).bind { | c |
      QueenCheck::Gen.unit(c.chr)
    }
  end

  class Alphabet
    class LowerCase
      arbitrary QueenCheck::Gen.choose(97, 122).bind { | c |
        QueenCheck::Gen.unit(c.chr)
      }
    end

    class UpperCase
      arbitrary QueenCheck::Gen.choose(65, 90).bind { | c |
        QueenCheck::Gen.unit(c.chr)
      }
    end

    arbitrary QueenCheck::Gen.one_of([LowerCase.arbitrary.gen, UpperCase.arbitrary.gen])
  end
end

class String
  arbitrary QueenCheck::Gen.quadratic(20000).bind { | length |
    if length.zero?
      QueenCheck::Gen.unit("")
    else
      QueenCheck::Gen.rand.resize(1, length).fmap { | r |
        str = []
        r.times { str << QueenCheck::ASCIIChar.arbitrary.gen.value(0)[0] }
        str.join()
      }
    end
  }
end
