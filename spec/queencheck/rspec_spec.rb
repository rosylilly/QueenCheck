require 'queencheck/rspec'

describe QueenCheck do
  QueenCheck('stadard check', String) { | x |
    x.class.should == String
  }

  verboseQueenCheck('verbose check', QueenCheck::ASCIIChar) { | x |
    x.size.should == 1
  }

  labelingQueenCheck('labelig check', {
    "x > y" => proc{|x,y| x > y },
    "x < y" => proc{|x,y| x < y },
    "x = y" => proc{|x,y| x == y },
  },Integer, Integer) do | x, y |
    (x + y).should == y + x
  end
end
