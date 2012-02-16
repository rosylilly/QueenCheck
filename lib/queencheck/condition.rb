module QueenCheck
  class Condition
    def initialize(&condition)
      @condition = condition
    end

    def match?(n)
      @condition.call(n)
    end

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

    # @method not_include?
    # @return [QueenCheck::Condition]
    def_not :include?

    # @return [QueenCheck::Condition]
    def self.instance_of?(klass)
      new { |n|
        n.instance_of?(klass)
      }
    end
    def_not :instance_of?

    def self.respond_to?(method)
      new { |n|
        n.respond_to?(method)
      }
    end
    def_not :respond_to?

    def self.nil?()
      new { |n|
        n.nil?
      }
    end
    def_not :nil?

    def self.empty?()
      new { |n|
        n.empty?
      }
    end
    def_not :empty?

    def self.equal?(m)
      new { |n|
        n == m
      }
    end
    def_not :equal?

    def self.orderd?
      new { |n|
        n.sort == n
      }
    end
    def_not :orderd?
  end
end
