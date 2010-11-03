credit_card_validator
    Ninju
    http://www.github.com/Ninju/credit_card_validator

== DESCRIPTION:

Validates credit card numbers using the Luhn algorithm

== SYNOPSIS:

  class CreditCard
    card :visa, :length => [13, 16], :format => /^44/
  end

  card = CreditCard.create( 4413431987263 )
  card.type #=> :visa
  card.valid? #=> true/false

  card = CreditCard.create( 1234523423 )
  card.type #=> :unknown
  card.valid? #=> false

== REQUIREMENTS:

* Validate cards according to luhn algorithm
* Differentiate type of card (Visa, AMEX, MasterCard etc)

== INSTALL:

#= not yet
  sudo gem install credit_card_validator

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
