module Guideline
  class Error
    attr_reader :line, :message, :path, :name

    def initialize(options)
      @line    = options[:line]
      @message = options[:message]
      @path    = options[:path]
      @name    = options[:name]
    end

    def render
      "%4d: %s" % [line, message]
    end
  end
end
