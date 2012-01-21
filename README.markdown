# QueenCheck

QueenCheck is random test library.

Inspired by QuickCheck library in Haskell.

## Usage

```ruby
require 'queencheck'

number = 100

check = QueenCheck.new(number, :+, Integer)

res = check.run(verbose: true) do | result, arguments, error |
    result == number + arguments[0]
end

puts "#{res[:passed]} / #{res[:examples]}"
```
