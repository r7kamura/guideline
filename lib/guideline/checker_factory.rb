module Guideline
  class CheckerFactory
    def initialize(options, *checker_classes)
      @options = options
      @checker_classes = checker_classes
    end

    def create
      @checker_classes.map do |klass|
        klass.new(options_for(klass))
      end
    end

    def options_for(klass)
      @options[klass.to_s] || {}
    end
  end
end
