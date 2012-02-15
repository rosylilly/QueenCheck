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

    def value(progress)
      v = @proc.call(progress, random)

      cond = @conditions.inject(true) { | bool, cond |
        bool && cond.match?(v)
      }

      return [v, cond]
    end

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
    # == Examples:
    #
    #     QueenCheck::Gen.elements_of(['a', 'b', 'c']).where(
    #       :include? => ['1', 'a', 'A'],
    #       :equal? => 'a'
    #     )
    def where(conditions)
      self.class.new(option.merge({
        :conditions => @conditions + conditions.to_a.map { | el |
          cond = el[0].to_s.sub(/([^\?])$/){$1 + '?'}
          QueenCheck::Condition.method(cond).call(el[1])
        }
      }), &@proc)
    end

    ## class methods:
    def self.choose(lo, hi)
      elements_of((lo .. hi).to_a)
    end

    def self.elements_of(ary)
      new({
        :min => 0,
        :max => ary.size
      }) { | p, r |
        ary[r]
      }
    end

    def self.one_of(ary)
      elements_of(ary).bind { | gen |
        gen
      }
    end

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
  end
end
