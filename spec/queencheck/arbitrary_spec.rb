require 'queencheck/arbitrary'

describe QueenCheck::Arbitrary do
  it "define" do
    class Klass
      arbitrary do | progress, rnd |
        rnd
      end
    end

    Klass.arbitrary.should be_instance_of(QueenCheck::Arbitrary)
    Class.arbitrary.should be_nil
  end
end
