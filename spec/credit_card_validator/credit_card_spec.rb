# spec/credit_card_validator/credit_card_spec.rb
#

require File.join( File.dirname( __FILE__ ), %w{ .. spec_helper } )

include CreditCardValidator

describe CreditCard do
  def card_number
    @card_number ||= 418997223921
  end

  it "should be unknown if the type is unknown" do
    card = CreditCard.create( 34123124 )
    card.stub( :type ).and_return( :unknown )
    card.should be_unknown
  end

  it "should not be unknown if the type of the card is known" do
    card = CreditCard.create( 34123124 )
    card.stub( :type ).and_return( :some_known_type )
    card.should_not be_unknown
  end

  it "should not be valid if the type of the card is unknown" do
    card = CreditCard.create( 4408041234567893 )
    card.stub( :type ).and_return( :unknown )
    card.should_not be_valid
  end

  it "should be valid if the luhn sum is divisible exactly by 10" do
    card = CreditCard.create( 4408041234567893 )
    card.should be_valid
  end

  it "should not be valid if the luhn sum is not divisible exactly by 10" do
    card = CreditCard.create( 4417123456789112 )
    card.should_not be_valid
  end

  describe "CreditCard class>>create" do
    before do
      CreditCard.stub( :type ).and_return( "Non Card" )
    end

    it "should return a card" do
      CreditCard.create( card_number ).should be_kind_of( CreditCard )
    end

    it "should raise an error when created with no arguments" do
      lambda { CreditCard.create }.should raise_error
    end

    it "should have the correct type" do
      CreditCard.should_receive( :type ).with( card_number ).and_return( "Super Card" )
      card = CreditCard.create( card_number )
      card.type.should == "Super Card"
    end

    it "should have the correct card number" do
      card = CreditCard.create( card_number )
      card.card_number.should == card_number
    end
  end

  describe "CreditCard class>>type" do
    before do
      CreditCard.stub( :card_types ).and_return( card_types )

      card_types.each do | type, rule |
        rule.stub( :call )
      end
    end

    def card_types
      @card_types ||= { "One" => Object.new }
    end

    it "should be 'Uknown' when the card number does not match any type" do
      card_types.each do | type, rule |
        rule.stub( :call ).with( card_number ).and_return( false )
      end

      CreditCard.type( card_number ).should == :unknown
    end

    it "should be the card type of the matching rule" do
      card_types.each do | type, rule |
        rule.stub( :call ).with( card_number ).and_return( true )
      end

      CreditCard.type( card_number ).should == card_types.keys.first
    end
  end

  describe "CreditCard class>>card" do
    before do
      CreditCard.stub( :rule_for_options )
      CreditCard.stub( :card_types ).and_return( card_types )
    end

    def card_types
      @card_types ||= { "One" => Object.new }
    end

    it "should add a new card type to the card_types with a rule based on the options passed" do
      options = { :length => [ 14, 16 ], :format => /^3(4|7)/ }
      CreditCard.stub( :rule_for_options ).with( options ).and_return( :some_rule )
      CreditCard.card( "New Card Type", options )

      card_types.should have_key( "New Card Type" )
      card_types[ "New Card Type" ].should == :some_rule
    end
  end

  describe "CreditCard class>>rule_for_options" do
    def options
      @options ||= { :length => [ 14, 16 ], :format => /^3(4|7)/ }
    end

    it "should return a callable object" do
      CreditCard.rule_for_options( options ).should respond_to( :call )
    end

    describe "when no options are passed" do
      it "should not raise an error" do
        lambda { CreditCard.rule_for_options }.should_not raise_error
      end

      it "should return a rule that is always true" do
        rule = CreditCard.rule_for_options
        rule.call.should be_true
      end
    end

    describe "when the :length option is passed" do
      it "should be true if the number of digits is equal to one of the lengths passed" do
        rule = CreditCard.rule_for_options( :length => [ 10, 14 ] )
        rule.call( 1234567890 ).should be_true
        rule.call( 12345678901234 ).should be_true
      end

      it "should be false if the number of digits is not equal to any of the lengths passed" do
        rule = CreditCard.rule_for_options( :length => [ 10, 14 ] )
        rule.call( 123456789 ).should be_false
        rule.call( 12345678901 ).should be_false
        rule.call( 123456789012345 ).should be_false
      end
    end

    describe "when the :format option is passed" do
      it "should return false if the card number does not match the format" do
        rule = CreditCard.rule_for_options( :format => /^978/ )
        rule.call( 25213492334 ).should be_false
      end

      it "should return true if the card number matches the format" do
        rule = CreditCard.rule_for_options( :format => /^978/ )
        rule.call( 97812398123 ).should be_true
      end
    end
  end
end
