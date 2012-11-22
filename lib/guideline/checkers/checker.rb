module Guideline
  class Checker
    def initialize(options = {})
      @options = options
    end

    def errors
      @errors ||= []
    end

    def add_error(options)
      errors << Error.new(
        :message => options[:message],
        :path    => options[:path],
        :line    => options[:line]
      )
    end

    def has_error?
      !errors.empty?
    end
  end
end
