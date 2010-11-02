# spec/credit_card_validator/array_spec.rb
#

require File.join( File.dirname( __FILE__ ), %w{ .. spec_helper } )

describe Array do
  it "should return all the elements with even indexes" do
    [ 0, 1, 2, 3, 4 ].even_indexes.should == [ 0, 2, 4 ]
  end

  it "should return all the elements with odd indexes" do
    [ 0, 1, 2, 3, 4 ].odd_indexes.should == [ 1, 3 ]
  end

  it "should select the elements at the indexes that are true for the block" do
    elements = [ 0, 1, 2, 3, 4 ].select_indexes do | idx |
      idx == 1 or idx == 4
    end

    elements.should == [ 1, 4 ]
  end

  it "should return the sum of the elements" do
    [ "a", "b", "c" ].sum.should == "abc"
  end
end
