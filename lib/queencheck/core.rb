require 'queencheck/arbitrary'

module QueenCheck
  class Runner
    class Example
    end

    MAX_GENERATE_COUNT    = 10000
    DEFAULT_EXAMPLE_COUNT = 100

    def initialize(*arbitraries, &block)
      @test_proc = block
      @arbitraries = []
      arbitraries.each do | arbitrary |
        if arbitrary.instance_of?(QueenCheck::Gen) || arbitrary.instance_of?(QueenCheck::Arbitrary)
          @arbitraries << arbitrary.respond_to?(:gen) ? arbitrary.gen : arbitrary
        else
          raise ArgumentError, "Not implemented `#{arbitrary}` arbitrary" if (arb = QueenCheck::Arbitrary(arbitrary)).nil?
          @arbitraries << arb.gen
        end
      end
    end
  end
end
