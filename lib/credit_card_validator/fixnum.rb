Fixnum.class_eval do
  def digits
    to_s.split( // ).map { | s | s.to_i }
  end

  def even?
    self % 2 == 0
  end

  def odd?
    not even?
  end
end
