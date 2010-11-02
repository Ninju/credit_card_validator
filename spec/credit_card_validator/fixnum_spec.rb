# spec/credit_card_vaildator/fixnum_spec.rb
#

require File.join( File.dirname( __FILE__ ), %w{ .. spec_helper } )

describe Fixnum do
  it "should return the digits as an array" do
    125.digits.should == [ 1, 2, 5 ]
  end

  it "should be even if it is divisible exactly by 2" do
    100.should be_even
  end

  it "should not be even if it is not divisible exactly by 2" do
    99.should_not be_even
  end

  it "should be odd if it is not divisible exactly by 2" do
    37.should be_odd
  end

  it "should not be odd if it is divisible exactly by 2" do
    2.should_not be_odd
  end

end
