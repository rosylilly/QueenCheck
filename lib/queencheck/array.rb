require 'queencheck/arbitrary'

class Array
  extend QueenCheck::Arbitrary

  @@bound = 10

  set_arbitrary do |seed|
    if seed == 0
      return []
    else
      base = ((@@bound * seed).ceil)

      ary = Array.new(rand(base) + 1)

      if seed > 0.3
        ary.map!{|ar| Array.new(rand(base) + 1) }
      end

      if seed > 0.5
        ary.map!{|ar| ar.map!{|a| Array.new(rand(base) + 1) } }
      end

      if seed > 0.8
        ary.map!{|ar| ar.map!{|a| a.map!{|item| Array.new(rand(base) + 1) } } }
      end

      return ary
    end
  end
end


