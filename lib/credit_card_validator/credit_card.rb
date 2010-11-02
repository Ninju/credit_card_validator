module CreditCardValidator
  class CreditCard
    attr_reader :type, :card_number

    def initialize( type, card_number )
      @type = type
      @card_number = card_number
    end

    def valid?
      digits = card_number.digits
      evens = digits.even_indexes
      odds = digits.odd_indexes.map { | n | n * 2 }

      sum = evens.sum + odds.inject { | n, o | o.digits.sum + n }

      sum % 10 == 0
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
      lengths = options.delete( :length )
      format = options.delete( :format )

      rules = [ lambda { true } ]

      if lengths
        rules << lambda do | card_number |
          lengths.to_a.include?( card_number.digits.size )
        end
      end

      if format
        rules << lambda do | card_number |
          card_number.to_s =~ format
        end
      end


      lambda do | card_number |
        rules.all? do | rule |
          rule.call( card_number )
        end
      end
    end

    def self.card_types
      @card_types ||= {}
    end

    card "Visa", :format => /^4/, :length => [ 13, 16 ]
    card "MasterCard", :format => /^5(1|5)/, :length => 16
    card "Discover", :format => /^6011/, :length => 16
    card "AMEX", :format => /^3(4|7)/, :length => 15
  end
end
