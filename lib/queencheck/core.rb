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
      @types = types
    end

    def run(config = QueenCheck::Config.new, &block)
      config = config.kind_of?(Hash) ? QueenCheck::Config.new(config) : config

      config.count.times do | n |
        range = (n+0.0) / config.count
        arguments = []
        @types.each do | type |
          arguments.push(type.arbitrary(range))
        end

        result, error = nil, false
        begin
          result = @method.call(*arguments)
        rescue => e
          result = e
          error = true
        end

        arguments.each_with_index do | n, i |
          print "#{@types[i]}: #{n}"
          print "\n"
        end if config.verbose?
        block.call(result, arguments, error)
      end
    end
  end
end
