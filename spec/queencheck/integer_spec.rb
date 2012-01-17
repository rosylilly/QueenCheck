describe Integer do
  it ".arbitrary" do
    100.times do 
      Integer.arbitrary(0).should be_zero
    end

    100.times do |n|
      n = n / 100.0
    end
  end
end
