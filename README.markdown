# QueenCheck [![Build Status](https://secure.travis-ci.org/rosylilly/QueenCheck.png)](http://travis-ci.org/rosylilly/QueenCheck) [![Gem Status](https://gemnasium.com/rosylilly/QueenCheck.png)](https://gemnasium.com/rosylilly/QueenCheck)

QueenCheck is random test library.

Inspired by QuickCheck library in Haskell.

## Usage

    $ gem install queencheck


## Example

    require 'queencheck'
    
    number = 100
    
    check = QueenCheck(number, :+, Integer)
    
    res = check.run(verbose: true) do | result, arguments, error |
    result == number + arguments[0]
    end
    
    puts "#{res.passes} / #{res.examples}"
