require 'queencheck'
require 'rspec'

module RSpec
  module Core
    class ExampleGroup
      def self.QueenCheck(name, *args, &block)
        describe(*[name]) {
          report = nil

          it "running tests" do
            report = ::QueenCheck::Testable.new(*args, &block).check
          end

          it "all tests passes" do
            report.count(:all).should == report.count(:success)
          end
        }
      end

      def self.verboseQueenCheck(name, *args, &block)
        describe(*[name]) {
          assert = proc { | *props |
            proc{ block.call(*props) }
          }
          its = proc { | *props |
            it("Gen: #{props.map{|i| i.inspect}.join(', ')}", &assert.call(*props))
          }
          ::QueenCheck::Testable.new(*args, &its).check
        }
      end

      def self.labelingQueenCheck(name, labels, *args, &block)
        checker = ::QueenCheck::Testable.new(*args, &block)
        report = checker.check_with_label(labels)
        describe(*[name]) {
          it "all tests passes" do
            report.count(:all).should == report.count(:success)
          end

          describe "labels" do
            labels.each_pair do | label, p |
              it label do
                report.count(label).should == report.count(label, report.successes)
              end
            end
          end
        }
      end
    end
  end
end
