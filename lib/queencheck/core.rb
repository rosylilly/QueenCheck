require 'queencheck/config'

module QueenCheck
  def self.new(*args)
    QueenCheck::Core.new(*args)
  end

  class Core
    def initialize(instance, method, *types)
      @instance = instance
      @method = method
      @types = types.map do | type |
        if type.respond_to?(:arbitrary?) && type.arbitrary?
          next type
        elsif type.kind_of?(Symbol)
          arb = QueenCheck::Arbitrary::Instance.get_by_id(type)
          next arb if arb
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

        stats.push(QueenCheck::Core::Task.new(@instance, @method, arguments).run!(&block))

        puts taks.to_s(true) if config.verbose?
      end

      return stats
    end

    class Result
      def initialize(examples)
        @examples = examples
        @tasks = []
      end
      attr_reader :examples

      def push(obj)
        @tasks.push(obj)
      end

      def [](index)
        @tasks[index]
      end

      def passes
        @tasks.reject {|task| !task.is_pass }.length
      end

      def failures
        @tasks.reject {|task| task.is_pass }.length
      end

      def tasks(filter = :pass)
        @tasks.reject {|task| task.is_pass == (filter == :pass ? false : true) }
      end
    end

    class Task
      def initialize(instance, method, args)
        @is_pass = nil
        @instance = instance
        @method = method
        @arguments = args
        @result = nil
        @exception = nil
      end
      attr_reader :is_pass, :instance, :method, :arguments, :result, :exception

      def run!(&check_block)
        return unless @is_pass.nil?
        func = @method.respond_to?(:call) ? @method : @instance.method(@method)

        begin
          @result = func.call(*@arguments)
        rescue Exception => e
          @exception = e
        end

        @is_pass = !!check_block.call(@result, @arguments, @exception) if check_block

        return self
      end

      def to_s(verbose = false)
        if verbose
          "<#{@instance.class.name}:#{@instance.object_id}>\##{@method.kind_of?(Method) ? @method.name : '::lambda::'}(" +
          @arguments.map { |arg| "#{arg.class.name}:#{arg}" }.join(', ') +
          ") => <#{@result.class.name}:#{@result}>" +
          (!@is_pass ? " !! #{@exception.class.name}: #{@exception.message}" : '')
        else
          "#{@instance.class.name}\##{@method.respond_to?(:call) ? '::lambda::' : @method}(" +
          @arguments.map {|arg| "#{arg}" } .join(', ') +
          ") => #{@result}" + (!@is_pass ? "! #{@exception.class.name}: #{@exception.message}": '')
        end
      end
    end
  end
end

def QueenCheck(*args)
  QueenCheck.new(*args)
end
