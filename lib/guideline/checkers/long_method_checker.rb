require "ripper"
require "ostruct"

module Guideline
  class LongMethodChecker < Checker
    def check(path)
      MethodParser.parse(path.read) do |method|
        if method.height > max
          add_error(
            :message => method.message,
            :line    => method.line,
            :path    => path
          )
        end
      end
    end

    private

    def max
      @options[:max] || 50
    end

    class Method < OpenStruct
      def message
        "Too long %3d lines method <#%s>" % [height, name]
      end
    end

    class MethodParser < Ripper
      class << self
        attr_reader :callback

        def parse(*, &callback)
          @callback = callback
          super
        end
      end

      private

      def on_def(name, *)
        start  = lineno_stack.pop
        finish = lineno
        height = finish - start - 1
        method = Method.new(
          :name   => name,
          :line   => start,
          :height => height
        )
        call(method)
        super
      end

      def on_kw(name)
        lineno_stack << lineno if name == "def"
        super
      end

      def lineno_stack
        @lineno_stack ||= []
      end

      def call(method)
        callback.call(method)
      end

      def callback
        self.class.callback
      end
    end
  end
end
