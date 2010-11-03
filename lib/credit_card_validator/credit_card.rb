module CreditCardValidator
  class CreditCard
    attr_reader :type, :card_number

    def initialize( type, card_number )
      @type = type
      @card_number = card_number
    end

    def unknown?
      type == :unknown
    end

    def valid?
      return false if unknown?

      digits = card_number.digits
      evens = digits.even_indexes
      odds = digits.odd_indexes.map { | n | n * 2 }

      sum = evens.sum + odds.inject { | n, o | o.digits.sum + n }

      sum % 10 == 0
    end

    def self.rules
      @rules ||= {}
    end

    def self.card_option( option_key, &block )
      rules[ option_key ] = block
    end

    def self.create( card_number )
      CreditCard.new( type( card_number ), card_number )
    end

    def self.type( card_number )
      card_type, rule = card_types.detect { | type, rule | rule.call( card_number ) }

      return card_type || :unknown
    end

    def self.card( type, options = {} )
      card_types[ type ] = rule_for_options( options )
    end

    def self.rule_for_options( options = {} )
      rules_to_use = rules.select { | key, rule | options.has_key?( key ) }

      lambda do | card_number |
        rules_to_use.all? do | key, rule |
          rule.call( options[ key ], card_number )
        end
      end
    end

    def self.card_types
      @card_types ||= {}
    end

    card_option( :format ) { | format, card_number | card_number.to_s =~ format }
    card_option( :length ) { | lengths, card_number | lengths.to_a.include?( card_number.digits.size ) }

    card :visa, :format => /^4/, :length => [ 13, 16 ]
    card :mastercard, :format => /^5(1|5)/, :length => 16
    card :discover, :format => /^6011/, :length => 16
    card :amex, :format => /^3(4|7)/, :length => 15
  end
end
