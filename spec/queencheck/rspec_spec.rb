require 'queencheck/rspec'

describe 'QueenCheck::RSpec' do
  qcheck 1, :+, [Integer] do | result, arguments, exception |
    result.should == arguments[0] + 1
  end

  qcheck 1, :/, [Integer] do | result, arguments, exception |
    if exception
      if exception.kind_of?(ZeroDivisionError)
        arguments[0].should == 0
      else
        raise exception
      end
    else
      result.should == 1 / arguments[0]
    end
  end
end
