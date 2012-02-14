require 'queencheck/arbitrary'

describe QueenCheck::Arbitrary do
  it "define" do
    class Klass
      arbitrary do | progress, rnd |
        rnd
      end
    end

    Klass.arbitrary.should be_instance_of(QueenCheck::Arbitrary)
    Klass.arbitrary?.should == true
    Class.arbitrary.should be_nil
    Class.arbitrary?.should == false
  end
end
