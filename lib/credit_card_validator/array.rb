Array.class_eval do
  def even_indexes
    select_indexes { | idx | idx.even? }
  end

  def odd_indexes
    select_indexes { | idx | idx.odd? }
  end

  def select_indexes( &block )
    ( 0..( size - 1 ) ).inject( [] ) do | ary, idx |
      if block.call( idx )
        ary << self[ idx ]
      else
        ary
      end
    end
  end

  def sum
    inject { | a, b | a + b }
  end
end
