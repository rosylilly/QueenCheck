
module QueenCheck
  class Config
    attr_reader :count, :log

    def initialize(options = nil)
      options ||= {}

      @count = options[:count] || 100 # デフォルトの試行回数は 100 回
      @verbose = options[:verbose] || false
      @log = options[:log] || STDOUT
    end

    def verbose?; @verbose; end
  end
end
