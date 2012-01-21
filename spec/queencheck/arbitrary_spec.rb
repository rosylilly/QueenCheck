require 'queencheck/arbitrary'

describe QueenCheck::Arbitrary do
  class Example
    extend QueenCheck::Arbitrary
  end

  it 'arbitrary' do
    expect {
      Example.arbitrary(1)
    }.to raise_error NotImplementedError

    Example.class_eval do
      def arbitrary(seed)
      end
    end
  end

  describe 'Original Arbitrary' do
    it 'new' do
      arb = QueenCheck::Arbitrary() do | seed |
        if seed < 0.5
          10**20
        else
          ""
        end
      end

      arb.arbitrary?.should be_true
      arb.arbitrary(0).should eq(10**20)
      arb.arbitrary(1).should eq("")
    end

    it 'named search' do
      arb = QueenCheck::Arbitrary(:sample) {}

      QueenCheck::Arbitrary(:sample).should eq(arb)
    end
  end
end

