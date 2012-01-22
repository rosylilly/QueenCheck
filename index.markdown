---
layout: default
title: Index
---

# About "QueenCheck"

QueenCheckはHaskellのテストライブラリである、QuickCheckを真似た、Ruby Libraryです。

## Usage

{% highlight ruby linenos %}
require 'queencheck'

number = 100
check = QueenCheck.new(number, :+, Integer)

res = check.run(verbose: true) do | result, arguments, error |
  result == number + arguments[0]
end

puts "#{res.passed} / #{res.examples}"
{% endhighlight %}

# Link

- [Repository on GitHub](https://github.com/rosylilly/QueenCheck)
- [queencheck | Rubygems.org](https://rubygems.org/gems/queencheck)
- [Travis-CI](http://travis-ci.org/rosylilly/QueenCheck)
