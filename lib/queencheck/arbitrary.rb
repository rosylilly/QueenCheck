require 'queencheck/gen'

module QueenCheck
  class << self
    def Arbitrary(name, gen = nil, &block)
      generator = gen || block

      generator.nil? ? Arbitrary.from_dic(name) : Arbitrary.new(name, generator)
    end
  end

  class Arbitrary
    @@dictionary = {}

    def initialize(name, gen)
      @gen = gen.instance_of?(QueenCheck::Gen) ? gen : QueenCheck::Gen.new(&gen)

      QueenCheck::Arbitrary.to_dic(name, self)
    end

    ## class methods:

    def self.to_dic(name, arb)
      name = name.respond_to?(:name) ? name.name : name.to_s
      @@dictionary[name] = arb
    end

    def self.from_dic(name)
      name = name.respond_to?(:name) ? name.name : name.to_s
      @@dictionary[name]
    end
  end
end

class Class
  def arbitrary(gen = nil, &block)
    QueenCheck::Arbitrary(name, gen || block)
  end
end
