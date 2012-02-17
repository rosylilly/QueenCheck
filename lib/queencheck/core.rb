require 'queencheck/exception'
require 'queencheck/arbitrary'
require 'queencheck/result'

module QueenCheck
  # QueenCheck Testable Object
  #
  # @example
  #   QueenCheck::Testable.new(Integer, Integer) do | x, y |
  #     x + y == y + x
  #   end
  class Testable
    # @param [Class(implmented arbitrary) or QueenCheck::Arbitrary or QueenCheck::Gen or Arbitrary Name] arbitraries
    # @param [Proc] assertion assert proc
    # @return [QueenCheck::Testable] new Testable instance
    # @example
    #   QueenCheck::Testable(Integer, Integer.arbitrary, Integer.arbitrary.gen, :Integer)
    def initialize(*arbitraries, &assertion)
      @arbitraries = arbitraries.map { | arbitrary |
        arb = (
          if arbitrary.instance_of?(QueenCheck::Arbitrary)
            arbitrary.gen
          elsif arbitrary.instance_of?(QueenCheck::Gen)
            arbitrary
          else
            QueenCheck::Arbitrary(arbitrary)
          end
        )
        raise TypeError, "Not Implemented Arbitrary or Gen: #{arbitrary}" if arb.nil?
        arb.instance_of?(QueenCheck::Arbitrary) ? arb.gen : arb
      }
      @assertion = assertion
    end

    DEFAULT_TEST_COUNT = 100

    # check assert
    # @param [Integer] count number of tests
    # @return [QueenCheck::ResultReport] ResultReport instance
    def check(count = DEFAULT_TEST_COUNT)
      results = QueenCheck::ResultReport.new
      count.times do | n |
        begin
          results << self.assert(n.to_f / count)
        rescue QueenCheck::CanNotRetryMore
          next
        end
      end
      return results
    end

    # check assert with label for report
    # @param [Hash] labels key is String. value is Proc.
    # @param [Integer] count number of tests
    # @return [QueenCheck::ResultReport] ResultReport instance
    # @example
    #   prop_int = QueenCheck::Testable(Integer, Integer){|x,y| true }
    #   prop_int.check_with_label(
    #     'x > y' => proc {|x,y| x > y}
    #   )
    def check_with_label(labels, count = DEFAULT_TEST_COUNT)
      sets = check(count)
      labels.each_pair do | label, proc |
        sets.labeling(label, &proc)
      end
      return sets
    end

    DEFAULT_RETRY_COUNT = 100

    private
    # @param [Float] progress 0 .. 1
    # @param [Integer] retry_count
    #
    # @return [Array<Object, Object ...>] generated values
    def properties(progress, retry_count = DEFAULT_RETRY_COUNT)
      @arbitraries.map { | gen |
        c = 0
        until (v = gen.value(progress))[1]
          c += 1
          raise QueenCheck::CanNotRetryMore, "can not retry generate: #{gen.inspect}" if c >= retry_count
        end
        v[0]
      }
    end

    def assert(progress)
      begin
        props = properties(progress)
        is_success = @assertion.call(*props)
      rescue => ex
        is_success = false
        exception = ex
      end
      QueenCheck::Result.new(props, is_success, exception)
    end
  end
end
