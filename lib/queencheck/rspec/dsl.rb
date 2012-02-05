module RSpec
  module Core
    class ExampleGroup
      def self.qcheck(instance, method, arbitraries, options = {}, &block)
        QueenCheck(instance, method, *arbitraries).run(options) do | result, args, error |
          it("#{instance}.#{method}(#{args.join(', ')})"){ 
            begin
              block.call(result, args, error)
            rescue
              raise $!
            end
          }
        end
      end
    end
  end
end
