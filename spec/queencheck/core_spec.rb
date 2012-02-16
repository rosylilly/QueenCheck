require 'queencheck'

prop_int = QueenCheck::Testable.new(
  QueenCheck::Gen.choose(0, 100),
  QueenCheck::Gen.choose(0, 100)
) { | x, y |
  x + y == y + x
}

puts prop_int.check_with_label(
  "x > y" => proc {|x, y| x > y },
  "x < y" => proc {|x, y| x < y },
  "x == y" => proc {|x, y| x == y }
).pretty_report
