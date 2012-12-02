require "code_analyzer"

module Guideline
  class UnusedMethodChecker < Checker
    def check(path)
      definition_visitor.check(path.to_s, path.read)
      report_unused_methods(path)
      clear_definitions
    end

    def prepare(path)
      call_visitor.check(path.to_s, path.read)
    end

    private

    def calls
      @calls ||= []
    end

    def call_visitor
      create_visitor(call_checker)
    end

    def call_checker
      MethodCallChecker.new do |method_name|
        calls << method_name
      end
    end

    def definitions
      @definitions ||= []
    end

    def definition_visitor
      create_visitor(definition_checker)
    end

    def definition_checker
      MethodDefinitionChecker.new do |definition|
        definitions << definition
      end
    end

    def create_visitor(checker)
      CodeAnalyzer::CheckingVisitor::Default.new(checkers: [checker])
    end

    def report_unused_methods(path)
      unused_methods.each do |method|
        report(
          :path    => path,
          :line    => method.line,
          :message => "Remove unused method <%s%s%s>" % [
            method.module_name,
            method.class_method ? "." : "#",
            method.name,
          ],
        )
      end
    end

    def unused_methods
      definitions.reject do |method|
        calls.include?(method.name)
      end
    end

    def clear_definitions
      definitions.clear
    end

    class MethodChecker < CodeAnalyzer::Checker
      def initialize(*, &callback)
        @callback = callback
        super
      end

      def call(method)
        @callback.call(method)
      end
    end

    class MethodDefinitionChecker < MethodChecker
      include Parser::Moduleable

      interesting_files /.*\.rb/
      interesting_nodes :def, :defs

      add_callback :start_def do |node|
        call(
          Definition.new(
            :line        => node.line,
            :name        => node.method_name.to_s,
            :module_name => current_module_name,
          )
        )
      end

      add_callback :start_defs do |node|
        call(
          Definition.new(
            :line         => node.line,
            :name         => node.method_name.to_s,
            :module_name  => current_module_name,
            :class_method => true,
          )
        )
      end
    end

    class MethodCallChecker < MethodChecker
      interesting_files /.*\.rb/
      interesting_nodes :call, :fcall, :vcall

      add_callback :start_call do |node|
        call(node.message.to_s)
      end

      add_callback :start_fcall do |node|
        call(node.message.to_s)
      end

      add_callback :start_vcall do |node|
        call(node.to_s)
      end
    end

    class Definition < OpenStruct
    end
  end
end
