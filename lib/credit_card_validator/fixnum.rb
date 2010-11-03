Fixnum.class_eval do
  def digits
    to_s.split( // ).map { | s | s.to_i }
  end
end
