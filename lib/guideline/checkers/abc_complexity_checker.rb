require "code_analyzer"

module Guideline
  class AbcComplexityChecker < Checker
    DEFAULT_MAX = 15

    def check(path)
      @current_path = path
      visitor.check(path.to_s, path.read)
      @current_path = nil
    end

    private

    def checker
      AbcParser.new do |complexity, method, module_name, class_method_flag|
        if complexity > max
          report(
            :path    => @current_path,
            :line    => method.line,
            :message => "ABC Complexity of method<%s%s%s>%3d should be less than %d" % [
              module_name,
              class_method_flag ? "." : "#",
              method.method_name,
              complexity,
              max,
            ]
          )
        end
      end
    end

    def visitor
      CodeAnalyzer::CheckingVisitor::Default.new(checkers: [checker])
    end

    def max
      (@options[:max] || DEFAULT_MAX).to_i
    end

    class AbcParser <  CodeAnalyzer::Checker
      ASSIGNMENT_NODES = [:assign, :opassign]
      BRANCH_NODES     = [:call, :fcall, :vcall, :zsuper, :yield0, :brace_block, :do_block]
      CONDITION_NODES  = [:else]
      CONDITION_TOKENS = [:==, :===, :"<>", :<=, :>=, :=~, :>, :<, :<=>]
      ALL_NODES        = ASSIGNMENT_NODES + BRANCH_NODES + CONDITION_NODES

      include Parser::Moduleable

      attr_reader :assignment, :branch, :condition

      interesting_files /.*\.rb/
      interesting_nodes :def, :defs, :binary, :zsuper, *ALL_NODES

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
        @current_method << node
        clear
      end

      add_callback :start_defs do |node|
        @current_method << node
        clear
      end

      add_callback :end_def do |node|
        @callback.call(complexity, @current_method.pop, current_module_name, false)
      end

      add_callback :end_defs do |node|
        @callback.call(complexity, @current_method.pop, current_module_name, true)
      end

      add_callback :start_binary do |node|
        @condition += 1 if condition_table[node[2]]
      end

      def initialize(*, &callback)
        clear
        @callback = callback
        @current_method = []
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
