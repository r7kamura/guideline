module Guideline
  class LongLineChecker < Checker
    def check(path)
      lines(path).each_with_index do |line, index|
        if line.has_error?
          add_error(
            :message => line.message,
            :path    => path,
            :line    => index + 1
          )
        end
      end
    end

    private

    def lines(path)
      path.each_line.map do |line|
        LineChecker.new(line, :max => max)
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
    end
  end
end
