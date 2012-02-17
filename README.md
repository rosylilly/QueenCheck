# QueenCheck [![Build Status](https://secure.travis-ci.org/rosylilly/QueenCheck.png)](http://travis-ci.org/rosylilly/QueenCheck) [![Gem Status](https://gemnasium.com/rosylilly/QueenCheck.png)](https://gemnasium.com/rosylilly/QueenCheck)

QueenCheck is random test library.

Inspired by QuickCheck library in Haskell.

## Usage

    $ gem install queencheck

or

    $ git clone git://github.com/rosylilly/QueenCheck.git QueenCheck
    $ cd QueenCheck
    $ bundle install
    $ bundle exec rake install

## CI Report

[See Travis-CI](http://travis-ci.org/#!/rosylilly/QueenCheck)

## Abstract

let's start DDT(Data Driven Testing)

    require 'queencheck'

    def plus(x, y)
      x + y
    end

    prop_Plus = QueenCheck::Testable.new(Integer, Integer) do | x, y |
      plus(x, y) == x + y
    end
    puts prop_Plus.check.pretty_report
    # Tests: 100
    #   ✓ Successes  : 100
    #   ✗ Failures   :   0
    #   ✷ Exceptions :   0

with `exception`, `labeling` and `where`

    def div(x, y)
      x / y # => raise ZeroDividedError if y == 0
    end

    prop_Div = QueenCheck::Testable.new(Integer, Integer) do | x, y |
      div(x, y) == x / y
    end
    puts prop_Div.check.pretty_report
    # Tests: 100
    #   ✓ Successes  :  99
    #   ✗ Failures   :   1
    #   ✷ Exceptions :   1

    puts prop_Div.check_with_label(
      "x > y" => proc{|x,y| x > y },
      "x < y" => proc{|x,y| x < y },
      "x = y" => proc{|x,y| x == y },
      "x is 0" => proc{|x,y| x.zero? },
      "y is 0" => proc{|x,y| y.zero? }
    ).pretty_report
    # Tests: 100
    #  ✓ Successes  :  99
    #    x > y  :  43
    #    x < y  :  56
    #    x = y  :   0
    #    x is 0 :   0
    #    y is 0 :   0
    #  ✗ Failures   :   1
    #    x > y  :   0
    #    x < y  :   0
    #    x = y  :   1
    #    x is 0 :   1
    #    y is 0 :   1
    #  ✷ Exceptions :   1
    #    x > y  :   0
    #    x < y  :   0
    #    x = y  :   1
    #    x is 0 :   1
    #    y is 0 :   1

    int_generater = Integer.arbitrary.gen # => QueenCheck::Gen
    nonzero_integer = int_generater.where{|num| !num.zero? }
    prop_DivSuccess = QueenCheck::Testable.new(nonzero_integer, nonzero_integer) do | x, y |
      div(x, y) == x / y
    end
    puts prop_DivSuccess.check_with_label(
      "x > y" => proc{|x,y| x > y },
      "x < y" => proc{|x,y| x < y },
      "x = y" => proc{|x,y| x == y },
      "x is 0" => proc{|x,y| x.zero? },
      "y is 0" => proc{|x,y| y.zero? }
    ).pretty_report
    # Tests: 99
    #   ✓ Successes  : 99
    #     x > y  : 55
    #     x < y  : 44
    #     x = y  :  0
    #     x is 0 :  0
    #     y is 0 :  0
    #   ✗ Failures   :  0
    #     x > y  :  0
    #     x < y  :  0
    #     x = y  :  0
    #     x is 0 :  0
    #     y is 0 :  0
    #   ✷ Exceptions :  0
    #     x > y  :  0
    #     x < y  :  0
    #     x = y  :  0
    #     x is 0 :  0
    #     y is 0 :  0
