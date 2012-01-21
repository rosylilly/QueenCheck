
module QueenCheck
  class << self
    def Arbitrary(name = nil, &block)
      if block.nil? && !name.nil?
        return QueenCheck::Arbitrary::Instance.get_by_id(name)
      else
        return QueenCheck::Arbitrary::Instance.new(name, &block)
      end
      nil
    end
  end
  module Arbitrary
    class NotQueenCheckArbitrary < StandardError; end

    def arbitrary?; true; end

    def arbitrary(seed)
      raise NotImplementedError
    end

    def set_arbitrary(&block)
      self.class_eval do
        define_method(:arbitrary, &block)
      end
    end

    class Instance
      @@collection = {}
      def self.get_by_id(name); return @@collection[name.to_s.to_sym]; end
      def self.collection=(c); @@collection = c; end
      def self.collection; @@collection; end

      def initialize(name = nil, &block)
        raise ArgumentError, "require block" if block.nil?
        @arbitrary_proc = block
        @name = name.to_s.to_sym unless name.nil?
        unless @name.nil?
          @@collection[@name] = self
        end
      end
      attr_reader :name

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
