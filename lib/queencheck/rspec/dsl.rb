module RSpec
  module Core
    class ExampleGroup
      def self.qcheck(instance, method, args, options = {}, &block)
        QueenCheck(instance, method, *args).run(options) do | result, args, error |
          it("#{instance}.#{method}(#{args.join(', ')})"){ 
            begin
              block.call(result, args, error)
            rescue Exception => e
              e.set_backtrace(e.backtrace.shift)
              raise e
            end
          }
        end
      end
    end
  end
end
