
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'credit_card_validator'
  authors  'Ninju'
  email    'el.zingo@gmail.com'
  url      'http://www.github.com/Ninju/credit_card_validator'
}

