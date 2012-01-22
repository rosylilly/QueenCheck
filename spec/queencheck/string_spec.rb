require 'queencheck/string'

describe String do
  it ".arbitrary?" do
    String.arbitrary?.should be_true
  end

  it ".arbitrary" do
    100.times do 
      String.arbitrary(0.05).match(/^[a-zA-Z]+$/).should_not be_nil
    end
  end
end
