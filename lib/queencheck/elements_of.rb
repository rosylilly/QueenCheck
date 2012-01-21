
module QueenCheck
  class << self
    def ElementsOf(name, elements = nil)
      if elements.nil? && !name.kind_of?(Array)
        return QueenCheck::ElementsOf.get_by_id(name)
      else
        return QueenCheck::ElementsOf.new(name, elements)
      end
    end
  end

  class ElementsOf
    @@instances = {}

    def self.get_by_id(id)
      return @@instances[id.to_s.to_sym]
    end

    attr_reader :elements, :name

    def arbitrary?; true; end

    def arbitrary(seed)
      @elements[rand(@elements.length)]
    end

    def initialize(name, elements = nil)
      if elements.nil? && name.kind_of?(Array)
        elements = name
        name = nil
      end

      raise ArgumentError, 'elements length require over 1' if !elements.respond_to?(:length) || elements.length < 0
      @elements = elements

      if name
        @name = name.to_s.to_sym
        @@instances[@name] = self
      end
    end
  end
end
