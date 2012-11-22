module Guideline
  class LongLineChecker < Checker
    def check(path)
      lines(path).select(&:has_error?).each do |line|
        add_error(
          :line    => line.lineno,
          :message => line.message,
          :path    => path
        )
      end
    end

    private

    def lines(path)
      path.each_line.map.with_index do |line, index|
        LineChecker.new(line, :max => max, :lineno => index + 1)
      end
    end

    def max
      @options[:max]
    end

    class LineChecker
      def initialize(line, options = {})
        @line    = line
        @options = options
      end

      def message
        actual = "%3d" % length
        limit  = "%3d" % max
        "Line length #{actual} should be less than #{limit} characters"
      end

      def has_error?
        length > max
      end

      def max
        @options[:max] || 80
      end

      def length
        @line.split(//).length
      end

      def lineno
        @options[:lineno]
      end
    end
  end
end
