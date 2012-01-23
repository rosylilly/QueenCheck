# QueenCheck [![Build Status](https://secure.travis-ci.org/rosylilly/QueenCheck.png)](http://travis-ci.org/rosylilly/QueenCheck)

QueenCheck is random test library.

Inspired by QuickCheck library in Haskell.

## Usage

```shell
gem install queencheck
```

```ruby
require 'queencheck'

number = 100

check = QueenCheck.new(number, :+, Integer)

res = check.run(verbose: true) do | result, arguments, error |
result == number + arguments[0]
end

puts "#{res.passes} / #{res.examples}"
```
