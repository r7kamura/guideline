require "ripper"

module Guideline
  class HashCommaChecker < Checker
    def check(path)
      HashParser.parse(path.read) do |line|
        report(
          :message => "There should be a comma after the last value of Hash",
          :line    => line,
          :path    => path
        )
      end
    end

    class HashParser < Ripper
      class << self
        attr_reader :callback

        def parse(*, &callback)
          @callback = callback
          super
        end
      end

      private

      def on_lbrace(token)
        push_stacks
      end

      def on_rbrace(token)
        call(lineno) if has_error?
        pop_stacks
      end

      def on_lbracket(token)
        push_stacks
      end

      def on_rbracket(token)
        pop_stacks
      end

      def on_lparen(token)
        push_stacks
      end

      def on_rparen(token)
        pop_stacks
      end

      def on_kw(token)
        case token
        when "do"
          push_stacks
        when "end"
          pop_stacks
        end
      end

      def on_op(token)
        increase_key if token == "=>"
      end

      def on_comma(token)
        increase_comma
      end

      def on_label(token)
        increase_key
      end

      def on_nl(token)
        increase_line
      end
      alias_method :on_ignored_nl, :on_nl

      def call(method)
        callback.call(method)
      end

      def callback
        self.class.callback
      end

      def has_error?
        line[-1] && key[-1] && comma[-1] &&
        line[-1] > 0 && key[-1] > comma[-1]
      end

      def key
        @key ||= []
      end

      def line
        @line ||= []
      end

      def comma
        @comma ||= []
      end

      def pop_stacks
        key.pop
        line.pop
        comma.pop
      end

      def push_stacks
        key   << 0
        line  << 0
        comma << 0
      end

      def increase_key
        key[-1] += 1 if key[-1]
      end

      def increase_line
        line[-1] += 1 if line[-1]
      end

      def increase_comma
        comma[-1] += 1 if key[-1]
      end
    end
  end
end
