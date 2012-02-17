module QueenCheck
  # QueenCheck condition class
  # @example
  #   QueenCheck::Alphabet::LowerCase.arbitrary.gen.where(:include? => ['a', 'b', 'c'])
  class Condition
    # @yield [value] generated value
    # @yieldreturn [Boolean] matched?
    def initialize(&condition)
      @condition = condition
    end

    # @param [Object] n any value
    # @return [Boolean] condition matched
    def match?(n)
      @condition.call(n)
    end

    # @visibility private
    # @macro def_not
    #   @method not_$1
    #   not $1
    #   @param (see QueenCheck::Condition.$1)
    #   @scope class
    #   @visibility public
    #   @return [QueenCheck::Condition]
    #   @see QueenCheck::Condition.$1
    def self.def_not(method_name)
      not_proc = proc { | *args |
        cond = self.method(method_name).call(*args)
        class << cond
          def match?(n)
            !@condition.call(n)
          end
        end

        return cond
      }

      (class << self; self; end).instance_eval do
        define_method('not_' + method_name.to_s, &not_proc)
      end
    end

    # check value in ary
    # 
    # @param [Array] ary
    # @return [QueenCheck::Condition]
    def self.include?(ary)
      new { |n|
        ary.include?(n)
      }
    end
    def_not :include?

    # check instance of klass
    # @param [Class] klass
    # @return [QueenCheck::Condition]
    def self.instance_of?(klass)
      new { |n|
        n.instance_of?(klass)
      }
    end
    def_not :instance_of?

    # check respond to method
    # @param [Symbol, String] method method name
    # @return [QueenCheck::Condition]
    def self.respond_to?(method)
      new { |n|
        n.respond_to?(method)
      }
    end
    def_not :respond_to?

    # check nil
    # @return [QueenCheck::Condition]
    def self.nil?()
      new { |n|
        n.nil?
      }
    end
    def_not :nil?

    # check empty
    # @return [QueenCheck::Condition]
    def self.empty?()
      new { |n|
        n.empty?
      }
    end
    def_not :empty?

    # check equal m
    # @param [Object] m
    # @return [QueenCheck::Condition]
    def self.equal?(m)
      new { |n|
        n == m
      }
    end
    def_not :equal?

    # check orderd array
    # @return [QueenCheck::Condition]
    def self.orderd?
      new { |n|
        n.sort == n
      }
    end
    def_not :orderd?
  end
end
