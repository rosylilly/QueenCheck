require 'queencheck/arbitrary'

class Boolean
  arbitrary QueenCheck::Gen.elements_of([true, false])
end
