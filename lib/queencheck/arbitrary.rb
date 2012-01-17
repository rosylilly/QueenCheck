
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
  end
end
