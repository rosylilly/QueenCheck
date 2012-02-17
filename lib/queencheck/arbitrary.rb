require 'queencheck/gen'

module QueenCheck
  class << self
    # set or get arbitrary
    # @overload Arbitrary(name)
    #   @param [#name or #to_s] name arbitrary name
    #   @return [QueenCheck::Arbitrary]
    # @overload Arbitrary(name, gen)
    #   @param [#name or #to_s] name arbitrary name
    #   @param [QueenCheck::Gen or Proc] gen arbitrary generator
    #   @return [Symbol or String] stored arbitrary name
    # @overload Arbitrary(name, &block)
    #   @param [#name or #to_s] name arbitrary name
    #   @param [Proc] block arbitrary generator source
    #   @return [Symbol or String] stored arbitrary name
    def Arbitrary(name, gen = nil, &block)
      generator = gen || block

      generator.nil? ? Arbitrary.from_dic(name) : Arbitrary.new(name, generator)
    end
  end

  # QueenCheck Arbitrary class
  # @example
  #   QueenCheck::Arbitrary(Integer, QueenCheck::Gen.unit(0))
  class Arbitrary
    @@dictionary = {}

    # new instance of QueenCheck::Arbitrary
    # @overload initialize(name, gen)
    #   @param [#name or #to_s] name arbitrary name
    #   @param [QueenCheck::Gen or Proc] gen arbitrary generater
    # @overload initialize(name, &block)
    #   @param [#name or #to_s] name arbitrary name
    #   @param [Proc] block arbitrary generater source
    def initialize(name, gen, &block)
      gen = block || gen
      @gen = gen.instance_of?(QueenCheck::Gen) ? gen : QueenCheck::Gen.new(&gen)
      @name = QueenCheck::Arbitrary.to_dic(name, self)
    end

    # @return [Symbol or String] arbitrary name
    attr_reader :name
    # @return [QueenCheck::Gen] arbitrary generater
    attr_reader :gen


    # store arbitrary to dictionary
    # @param [#name or #to_s] name arbitrary name
    # @param [QueenCheck::Arbitrary] arb store arbitrary
    # @return [Symbol or String] stored arbitrary name
    def self.to_dic(name, arb)
      name = name.respond_to?(:name) ? name.name : name.to_s
      @@dictionary[name] = arb
      return name
    end

    # get arbitrary from dictionary
    # @param [#name or #to_s] name arbitrary name
    # @return [QueenCheck::Arbitrary or nil] QueenCheck::Arbitrary where hit name dictionary
    def self.from_dic(name)
      name = name.respond_to?(:name) ? name.name : name.to_s
      @@dictionary[name]
    end
  end
end

class Class
  # set arbitrary to class or get arbitrary of class
  # @overload arbitrary(gen)
  #   @param [QueenCheck::Gen] gen generater of arbitrary
  # @overload arbitrary(&block)
  #   @param [Proc] block proc of new QueenCheck::Gen instance
  # @return [QueenCheck::Arbitrary] arbitrary of class
  # @example
  #   class Klass
  #     arbitrary QueenCheck::Gen.choose(0, 100)
  #     #=> QueenCheck::Arbitrary
  #   end
  #   Klass.arbitrary #=> QueenCheck::Arbitrary
  #
  #   # set arbitrary
  #   Klass.arbitrary {|p, r| Klass.new }
  # @see QueenCheck::Arbitrary
  def arbitrary(gen = nil, &block)
    QueenCheck::Arbitrary(name, gen || block)
  end

  # check implemented arbitrary on class
  # @return [Boolean] implemented arbitrary
  def arbitrary?
    !QueenCheck::Arbitrary(name).nil?
  end
end
