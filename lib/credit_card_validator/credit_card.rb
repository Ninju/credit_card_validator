module CreditCardValidator
  class CreditCard
    attr_reader :type, :card_number

    def initialize( type, card_number )
      @type = type
      @card_number = card_number
    end

    def self.create( card_number )
      CreditCard.new( type( card_number ), card_number )
    end

    def self.type( card_number )
      card_type, rule = card_types.detect { | type, rule | rule.call( card_number ) }

      return card_type || "Uknown"
    end

    def self.card( type, options = {} )
      card_types[ type ] = rule_for_options( options )
    end

    def self.rule_for_options( options = {} )
      lambda { true }
    end
  end
end
