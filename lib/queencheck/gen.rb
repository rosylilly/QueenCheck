require 'queencheck/condition'

module QueenCheck
  class Gen
    DEFAULT_BOUND = 1000

    # @param [Hash] options generater options
    # @option options [Integer] :min bound min
    # @option options [Integer] :max bound max
    # @option options [Array<QueenCheck::Condition>] :conditions array of conditions
    # @yield [p, r] progress and random int
    def initialize(options = {}, &block)
      @proc = block

      @bound_min  = options['min'] || options[:min] || 0
      @bound_max  = options['max'] || options[:max] || DEFAULT_BOUND
      @conditions = options['conditions'] || options[:conditions] || []
    end

    # get value form generater
    #
    # @param [Float] progress 0 .. 1
    # @return [Array<Any, Boolean>] Any Value & Condition Matched
    def value(progress)
      v = @proc.call(progress, random)

      cond = @conditions.inject(true) { | bool, cond |
        bool && cond.match?(v)
      }

      return [v, cond]
    end

    # @return [Integer] random int in @bound_min .. @bound_max
    def random
      (@bound_min + rand * (@bound_max - @bound_min)).to_i
    end

    # @return [Hash] option
    def option
      {
        :min        => @bound_min,
        :max        => @bound_max,
        :conditions => @conditions
      }
    end

    # @private
    def inspect
      "<QueenCheck::Gen: {#{@proc.to_s}}>"
    end

    # resize bound of generater
    #
    # @param [Integer] lo lower bound
    # @param [Integer] hi higher bound
    # @example
    #     QueenCheck::Gen.rand.resize(-100, 100) == QueenCheck::Gen.choose(-100, 100)
    # @return [QueenCheck::Gen]
    def resize(lo, hi)
      self.class.new(option.merge({
        :min => lo,
        :max => hi
      }), &@proc)
    end

    # bind function
    # @yield [x] x is generated value
    # @yieldreturn [QueenCheck::Gen]
    # @return [QueenCheck::Gen]
    def bind
      self.class.new(option) { | p, r |
        yield(value(p)[0]).value(p)[0]
      }
    end

    # @yield [x] x is generated value
    # @yieldreturn [Object]
    # @return [QueenCheck::Gen]
    def fmap
      bind { | x |
        self.class.unit(yield(x))
      }
    end

    # set conditions
    #
    # @overload where(conditions)
    #   @param [Hash] conditions { conditon_name => condition_param }
    #   @option conditions [QueenCheck::Condition] any_primitive_condition see QueenCheck::Condition
    # @overload where(){|value| ... }
    #   @yield [value] value is generated value
    #   @yieldreturn [Boolean]
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

    # one of generater
    # @param [Array<QueenCheck::Gen>] ary list of Generaters
    # @example
    #   QueenCheck::Gen.one_of([
    #     QueenCheck::Gen.elements_of([0, 1, 3]),
    #     QueenCheck::Gen.elements_of(["A", "B", "C"])
    #   ])
    # @return [QueenCheck::Gen]
    def self.one_of(ary)
      elements_of(ary).bind { | gen |
        gen.instance_of?(QueenCheck::Gen) ? gen : (
          gen.instance_of?(QueenCheck::Arbitrary) ? 
            gen.gen : QueenCheck::Arbitrary(gen).gen
        )
      }
    end

    # frequency generater
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

    # progress generater
    # @return [QueenCheck::Gen]
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

        gen.instance_of?(QueenCheck::Gen) ? gen : (
          gen.instance_of?(QueenCheck::Arbitrary) ? 
            gen.gen : QueenCheck::Arbitrary(gen).gen
        )
      }
    end

    # quadratic function (general form) generater
    # f(x) = ax^2 + bx + c
    # @param [Integer] a factor a
    # @param [Integer] b facror b
    # @param [Integer] c factor c
    # @return [QueenCheck::Gen]
    def self.quadratic(a, b = 1, c = 0)
      new { |p, r|
        (a * (p ** 2)) + (b * p) + c
      }
    end
  end
end
