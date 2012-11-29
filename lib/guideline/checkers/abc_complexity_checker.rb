require "ripper"

module Guideline
  class AbcComplexityChecker < Checker
    def check(path)
      @current_path = path
      visitor.check(path.to_s, path.read)
      @current_path = nil
    end

    private

    def checker
      AbcParser.new do |complexity, method, module_name|
        if complexity > max
          report(
            :path    => @current_path,
            :line    => method.line,
            :message => "Too abc-complex (%3d) method<#{module_name} #{method.method_name}>" % complexity
          )
        end
      end
    end

    def visitor
      CodeAnalyzer::CheckingVisitor::Default.new(checkers: [checker])
    end

    def max
      @options[:max]
    end

    module Moduleable
      def self.included(base)
        base.class_eval do
          interesting_nodes :class, :module

          add_callback :start_class do |node|
            modules << node.class_name.to_s
          end

          add_callback :start_module do |node|
            modules << node.module_name.to_s
          end

          add_callback :end_class do |node|
            modules.pop
          end

          add_callback :end_module do |node|
            modules.pop
          end
        end
      end

      def current_module_name
        modules.join("::")
      end

      def modules
        @moduels ||= []
      end
    end

    class AbcParser <  CodeAnalyzer::Checker
      ASSIGNMENT_NODES = [:assign, :opassign]
      BRANCH_NODES     = [:call, :fcall, :vcall, :brace_block, :do_block]
      CONDITION_NODES  = [:else]
      CONDITION_TOKENS = [:==, :===, :"<>", :"<=", :">=", :"=~", :>, :<, :"<=>"]
      ALL_NODES        = ASSIGNMENT_NODES + BRANCH_NODES + CONDITION_NODES

      include Moduleable

      attr_reader :assignment, :branch, :condition

      interesting_files /.*\.rb/
      interesting_nodes :def, :binary, *ALL_NODES

      ASSIGNMENT_NODES.each do |name|
        add_callback :"start_#{name}" do |node|
          @assignment += 1
        end
      end

      BRANCH_NODES.each do |name|
        add_callback :"start_#{name}" do |node|
          @branch += 1
        end
      end

      CONDITION_NODES.each do |name|
        add_callback :"start_#{name}" do |node|
          @condition += 1
        end
      end

      add_callback :start_def do |node|
        @current_method = node
        clear
      end

      add_callback :end_def do |node|
        @callback.call(complexity, @current_method, current_module_name)
        @current_method = nil
      end

      add_callback :start_binary do |node|
        @condition += 1 if condition_table[node[2]]
      end

      def initialize(*, &callback)
        clear
        @callback = callback
        super
      end

      def clear
        @assignment = 0
        @branch     = 0
        @condition  = 0
      end

      def complexity
        Math.sqrt(@assignment ** 2 + @branch ** 2 + @condition ** 2)
      end

      def condition_table
        @condition_table ||= CONDITION_TOKENS.inject({}) do |hash, token|
          hash[token] = true
          hash
        end
      end
    end
  end
end
