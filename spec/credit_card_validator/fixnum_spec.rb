# spec/credit_card_vaildator/fixnum_spec.rb
#

require File.join( File.dirname( __FILE__ ), %w{ .. spec_helper } )

describe Fixnum do
  it "should return the digits as an array" do
    125.digits.should == [ 1, 2, 5 ]
  end
end
