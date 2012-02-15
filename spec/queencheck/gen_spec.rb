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

  it "#one_of" do
    one_of = QueenCheck::Gen.one_of([
      QueenCheck::Gen.elements_of([1, 2, 3]),
      QueenCheck::Gen.choose(5, 10)
    ])

    10000.times do | n |
      v = one_of.value(n)[0]
      v.should >= 1
      v.should <= 10
      v.should_not == 4
    end
  end

  it "#where" do
    gen = QueenCheck::Gen.choose(0, 10)

    include_gen = gen.where(
      :include => [0,2,3]
    ).where(
      :not_equal => 0
    )
    10000.times do | n |
      v = include_gen.value(n)
      [2, 3].include?(v[0]).should == v[1]
    end
  end

  it "#frequency" do
    gen = QueenCheck::Gen.frequency([
      [1, QueenCheck::Gen.elements_of([0])],
      [3, QueenCheck::Gen.elements_of([1])]
    ])

    stat = {
      :a => 0,
      :b => 0
    }
    10000.times do | n |
      v = gen.value(n)
      if v[0] == 0
        stat[:a] += 1
      else
        stat[:b] += 1
      end
    end
    stat[:a].should <= stat[:b]
  end
end
