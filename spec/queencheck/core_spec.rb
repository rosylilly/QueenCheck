describe QueenCheck do
  before(:each) do
    @checker = QueenCheck.new(3, :+, Integer)
  end

  it 'quick test' do
    @checker.run do | result, arguments |
      result.should == 3 + arguments[0]
    end
  end

  it 'verbose run' do
    @checker.run(verbose: true) do | result, arguments |
      result.should == 3 + arguments[0]
    end
  end
end

