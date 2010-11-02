# spec/credit_card_validator/credit_card_spec.rb
#

require File.join( File.dirname( __FILE__ ), %w{ .. spec_helper } )

include CreditCardValidator

describe CreditCard do
  def card_number
    @card_number ||= 418997223921
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

    it "should return a string representation of the Card's type" do
      CreditCard.type( card_number ).should be_kind_of( String )
    end

    it "should be 'Uknown' when the card number does not match any type" do
      card_types.each do | type, rule |
        rule.stub( :call ).with( card_number ).and_return( false )
      end

      CreditCard.type( card_number ).should == "Uknown"
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
  end
end
