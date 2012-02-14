require 'queencheck/gen'

describe QueenCheck::Gen do
  it "initialize" do
    QueenCheck::Gen.new { | progress, rnd |
      [progress, rnd]
    }.should be_instance_of(QueenCheck::Gen)
  end

  it "#choose" do
    choose = QueenCheck::Gen.choose(0, 100)
    choose.should be_instance_of(QueenCheck::Gen)
    10000.times do | n |
      v = choose.value(n)[0]
      v.should >= 0
      v.should <= 100
    end
  end

  it "#where" do
    gen = QueenCheck::Gen.choose(0, 10)

    include_gen = gen.where(
      :include => [0,2,3]
    ).where(
      :not_equal => 0
    )
    10.times do | n |
      v = include_gen.value(n)
      [2, 3].include?(v[0]).should == v[1]
    end
  end
end
