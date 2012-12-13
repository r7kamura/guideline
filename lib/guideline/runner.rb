module Guideline
  class Runner
    def self.run
      new.run
    end

    def run
      puts renderer.detail if options[:detail] != false
      puts
      puts renderer.summary
    end

    private

    def renderer
      @renderer ||= Renderer.new(errors)
    end

    def visitor
      @visitor ||= Visitor.new(options[:path], enable_checkers)
    end

    def errors
      visitor.prepare
      visitor.visit
      visitor.errors
    end

    def enable_checkers
      array = []
      array << abc_complexity_checker      if options[:abc_complexity]      != false
      array << hard_tab_indent_checker     if options[:hard_tab_indent]     != false
      array << hash_comma_checker          if options[:hash_comma]          != false
      array << long_line_checker           if options[:long_line]           != false
      array << long_method_checker         if options[:long_method]         != false
      array << trailing_whitespace_checker if options[:trailing_whitespace] != false
      array << unused_method_checker       if options[:unused_method]       != false
      array
    end

    def options
      @options ||= OptionParser.parse
    end

    def abc_complexity_checker
      AbcComplexityChecker.new(:max => options[:abc_complexity])
    end

    def hard_tab_indent_checker
      HardTabIndentChecker.new
    end

    def hash_comma_checker
      HashCommaChecker.new
    end

    def long_line_checker
      LongLineChecker.new(:max => options[:long_line])
    end

    def long_method_checker
      LongMethodChecker.new(:max => options[:long_method])
    end

    def trailing_whitespace_checker
      TrailingWhitespaceChecker.new
    end

    def unused_method_checker
      UnusedMethodChecker.new
    end
  end
end
