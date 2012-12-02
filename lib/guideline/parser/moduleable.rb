module Guideline
  class Parser
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
  end
end
