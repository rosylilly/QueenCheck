require 'queencheck/config'

module QueenCheck
  def new(*args)
    QueenCheck::Core.new(*args)
  end
  
  module_function :new

  class Core
    def initialize(instance, method, *types)
      @instance = instance
      @method = method.respond_to?(:call) ? method : instance.method(method.to_s.to_sym)
      @types = []
      types.each do | type |
        if type.respond_to?(:arbitrary?) && type.arbitrary?
          @types << type
          next
        elsif types.kind_of?(Symbol)
          type = QueenCheck::Arbitrary::Instance.get_by_id(type)
          unless type.nil?
            @types << type
            next
          end
        end
        raise QueenCheck::Arbitrary::NotQueenCheckArbitrary, "`#{type}` is not implemented arbitrary"
      end
    end

    def run(config = QueenCheck::Config.new, &block)
      config = config.kind_of?(Hash) ? QueenCheck::Config.new(config) : config

      stats = QueenCheck::Core::Result.new(config.count)

      config.count.times do | n |
        range = n.to_f / config.count
        arguments = []
        @types.each do | type |
          arguments.push(type.arbitrary(range))
        end

        arguments.each_with_index do | n, i |
          puts "#{@types[i]}: #{n}"
        end if config.verbose?

        result, error = nil, nil
        begin
          result = @method.call(*arguments)
        rescue Exception => e
          error = e
        end

        is_exception = false
        begin
          test_result = block.call(result, arguments, error)
        rescue Exception => e
          error = e
          is_exception = true
        end

        if config.verbose?
          print "#{@instance.kind_of?(Class) ? @instance.name : @instance.class.name} \##{@method.respond_to?(:name) ? @method.name : @method.class} ("
          print @types.map{|type| "#{type.name}" }.join(', ') + ')'
          puts " => #{is_exception ? error.class : test_result}"
        end

        unless is_exception
          case test_result
          when true
            stats.passed += 1
          when false
            stats.failures += 1
          end
        else
          stats.add_exception(error)
        end

      end

      return stats
    end

    class Result
      def initialize(examples)
        @examples = examples
        @passed = 0
        @failures = 0
        @exceptions = []
      end
      attr_reader :examples, :passed, :failures

      def passed=(n)
        raise RangeError if n > @examples
        @passed = n
      end

      def failures=(n)
        raise RangeError if n > @examples
        @failures = n
      end

      def exceptions; return @exceptions.length; end

      def add_exception(e)
        @exceptions.push(e)
      end
    end
  end
end

def QueenCheck(*args)
  QueenCheck.new(*args)
end
