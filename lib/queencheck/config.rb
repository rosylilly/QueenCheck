
module QueenCheck
  class Config
    attr_reader :count

    def initialize(options = nil)
      options ||= {}

      @count = options[:count] || 100
      @verbose = options[:verbose] || false
    end

    def verbose?; @verbose; end
  end
end
