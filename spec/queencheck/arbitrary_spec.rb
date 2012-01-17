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
end

