require 'queencheck/condition'

module QueenCheck
  class Gen
    DEFAULT_BOUND = 1000

    def initialize(options = {}, &block)
      @proc = block

      @bound_min  = options['min'] || options[:min] || 0
      @bound_max  = options['max'] || options[:max] || DEFAULT_BOUND
      @conditions = options['conditions'] || options[:conditions] || []
    end

    # get value form generater
    #
    # @param progress [Intger] > 0
    # @return [Array<Any, Boolean>] Any Value & Condition Matched
    def value(progress)
      v = @proc.call(progress, random)

      cond = @conditions.inject(true) { | bool, cond |
        bool && cond.match?(v)
      }

      return [v, cond]
    end

    # @return [Integer]
    def random
      (@bound_min + rand * (@bound_max - @bound_min)).to_i
    end

    def option
      {
        :min        => @bound_min,
        :max        => @bound_max,
        :conditions => @conditions
      }
    end

    def inspect
      "<QueenCheck::Gen: {#{@proc.to_s}}>"
    end

    # resize bound of generater
    #
    #     QueenCheck::Gen.rand.resize(-100, 100) == QueenCheck::Gen.choose(-100, 100)
    #
    # @return [QueenCheck::Gen]
    def resize(lo, hi)
      self.class.new(option.merge({
        :min => lo,
        :max => hi
      }), &@proc)
    end

    def bind
      self.class.new(option) { | p, r |
        yield(value(p)[0]).value(p)[0]
      }
    end

    # set conditions
    #
    # @param [Hash] conditions { conditon_name => condition_param }
    #
    # @see QueenCheck::Condition
    #
    # @return [QueenCheck::Gen] new generater
    #
    # @example
    #     QueenCheck::Gen.elements_of(['a', 'b', 'c']).where(
    #       :include? => ['1', 'a', 'A'],
    #       :equal? => 'a'
    #     )
    #
    #     QueenCheck::Gen.choose(0, 100).where { |v|
    #       v.odd?
    #     }
    def where(conditions = {}, &block)
      self.class.new(option.merge({
        :conditions => @conditions + conditions.to_a.map { | el |
          cond = el[0].to_s.sub(/([^\?])$/){$1 + '?'}
          QueenCheck::Condition.method(cond).call(el[1])
        } + (
          !block.nil? ? [QueenCheck::Condition.new(&block)] : []
        )
      }), &@proc)
    end

    ## class methods:
   
    # choose value where >= lo and <= hi
    # @param [Integer] lo bound min
    # @param [Integer] hi bound max
    # @example
    #   QueenCheck::Gen.choose(0, 100)
    # @return [QueenCheck::Gen]
    def self.choose(lo, hi)
      elements_of((lo .. hi).to_a)
    end

    # choose value from ary
    # @param [Array] ary
    # @example
    #   QueenCheck::Gen.elements_of([0, 1, 2])
    # @return [QueenCheck::Gen]
    def self.elements_of(ary)
      new({
        :min => 0,
        :max => ary.size
      }) { | p, r |
        ary[r]
      }
    end

    # @param [Array<QueenCheck::Gen>] ary list of Generaters
    # @example
    #   QueenCheck::Gen.one_of([
    #     QueenCheck::Gen.elements_of([0, 1, 3]),
    #     QueenCheck::Gen.elements_of(["A", "B", "C"])
    #   ])
    # @return [QueenCheck::Gen]
    def self.one_of(ary)
      elements_of(ary).bind { | gen |
        gen
      }
    end

    # @param [Array<[weight[Integer], QueenCheck::Gen]>] ary list of pairs weight and generater
    # @example
    #   QueenCheck::Gen.frequency([
    #     [1, QueenCheck::Gen.elements_of(['a', 'b', 'c'])],
    #     [2, QueenCheck::Gen.elements_of(['1', '2', '3'])]
    #   ])
    #   # propability of 1/3 => 'a', 'b' or 'c'
    #   # propability of 2/3 => '1', '2' or '3'
    # @return [QueenCheck::Gen]
    def self.frequency(ary)
      generaters = []
      ary.each do | pair |
        pair[0].times do 
          generaters << pair[1]
        end
      end
      raise ArgumentsError, "frequency: illigal weight total N > 0" if generaters.empty?

      one_of(generaters)
    end

    # random generater
    # @example
    #   QueenCheck::Gen.rand.resize(-100, 100)
    # @return [QueenCheck::Gen]
    def self.rand
      new { | p, r |
        r
      }
    end

    # unit generater
    # @param [Object] n any object
    # @example
    #   QueenCheck::Gen.unit(1)
    #   # always generate 1
    # @return [QueenCheck::Gen]
    def self.unit(n)
      new {
        n
      }
    end

    def self.progress
      new { | p, r |
        p
      }
    end

    # step up generater
    # @param [Array<[weight, Gen]>] ary
    # @example
    #   QueenCheck::Gen.step_up([
    #     [1, QueenCheck::Gen.elements_of(['a', 'b', 'c'])],
    #     [2, QueenCheck::Gen.elements_of(['A', 'B', 'C'])]
    #   ])
    # @return [QueenCheck::Gen]
    def self.step_up(ary)
      total = ary.inject(0) { | total, pair | total + pair.first }

      self.progress.bind { |p, r|
        index = total * p

        gen = nil
        ary.each do | pair |
          gen = pair.last 
          break if index <= pair.first
          index -= pair.first
        end

        gen
      }
    end

    def self.quadratic(x, y = 1, z = 0)
      new { |p, r|
        (x * (p ** 2)) + (y * p) + z
      }
    end
  end
end
