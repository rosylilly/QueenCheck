require 'queencheck/elements_of'

describe QueenCheck::ElementsOf do
  before(:each) do
    @samples = ['a', 'b', 'c']
    @elements_of = QueenCheck::ElementsOf.new(@samples)
  end

  it 'choose one' do
    100.times do
      @samples.should be_include(@elements_of.arbitrary(rand(10).to_f / 10))
    end
  end

  it 'named type' do
    named = QueenCheck::ElementsOf(:names, ['test', 'sample'])

    named.should be_kind_of(QueenCheck::ElementsOf)
    QueenCheck::ElementsOf(:names).should eq(named)
    QueenCheck::Arbitrary(:elements_of_names).should eq(named)
  end
end
