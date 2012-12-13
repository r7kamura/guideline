module Guideline
  class Checker
    def initialize(options = {})
      @options = options
    end

    def errors
      @errors ||= []
    end

    def report(options)
      errors << Error.new(
        :line    => options[:line],
        :message => options[:message],
        :path    => options[:path],
        :name    => name
      )
    end

    def has_error?
      !errors.empty?
    end

    private

    def name
      @name ||= self.class.to_s.split("::").last
    end
  end
end
