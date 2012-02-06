require 'pp'

module RSpec
  module Core
    class ExampleGroup
      def self.qcheck(instance, method, arbitraries, options = {}, &block)
        describe "QC: #{instance.class}##{method}(#{arbitraries.join(', ')})" do
          QueenCheck(instance, method, *arbitraries).run(options) do | result, args, error |
            it("Gen: #{args.join(', ')}"){ 
              begin
                self.instance_eval_with_args(*[result, args, error], &block)
              rescue => e
                e.set_backtrace(e.backtrace.slice(0,6) + e.backtrace.slice(9, 100))
                raise e
              end
            }
          end
        end
      end
    end
  end
end
