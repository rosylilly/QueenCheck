
module QueenCheck
  module Arbitrary
    class NotQueenCheckArbitrary < StandardError; end

    def arbitrary?; true; end

    def arbitrary(seed)
      raise NotImplementedError
    end

    def set_arbitrary(&block)
      self.class_eval do
        define_singleton_method(:arbitrary, &block)
      end
    end

    def generate(&block)
      QueenCheck::Arbitrary::Instance.new(&block)
    end
    module_function :generate

    class Instance
      def initialize(&block)
        raise ArgumentError, "require block" if block.nil?
        @arbitrary_proc = block
      end

      def arbitrary?; true; end

      def arbitrary(seed)
        @arbitrary_proc.call(seed)
      end
    end
  end
end

class BasicObject
  def arbitrary?; false; end
end
