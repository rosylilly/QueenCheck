describe QueenCheck do
  before(:each) do
    @checker = QueenCheck.new(3, :+, Integer)
  end

  it 'quick test' do
    ret = @checker.run do | result, arguments |
      result.should == 3 + arguments[0]
    end

    ret[:examples].should eq(100)
    ret[:passed].should eq(100)
    ret[:failures].should eq(0)
  end

  it 'verbose run' do
    @checker.run(verbose: true, count: 100) do | result, arguments |
      result.should == 3 + arguments[0]
    end
  end

  it 'exception' do
    div = QueenCheck.new(5, :/, Integer)

    ret = div.run do | result, arguments, error |
    end

    ret[:examples].should eq(1)
    ret[:exception].should eq(1)
  end
end

