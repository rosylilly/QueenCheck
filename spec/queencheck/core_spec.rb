require 'queencheck/core'

QueenCheck::Arbitrary(Integer, QueenCheck::Gen.choose(-100, 100))

describe QueenCheck::Runner do
  it "run" do
    QueenCheck::Runner.new(Integer, Integer) do | x, y |
      x + y == y + x
    end
  end
end
