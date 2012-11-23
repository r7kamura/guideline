require "yaml"
require "slop"

module Guideline
  module Runner
    extend self

    def parse(argv)
      hash = Parser.parse(argv)
      hash[:config] = load_config(hash[:config])
      hash
    end

    private

    def load_config(path)
      hash = load_yaml(path || default_config_path)
      HashWithIndifferentAccess.new(hash)
    end

    def load_yaml(path)
      YAML.load_file(path)
    rescue Errno::ENOENT
      raise "No such config file - #{path}"
    end

    def default_config_path
      File.expand_path("../../../guideline.yml", __FILE__)
    end

    class Parser
      def self.parse(argv)
        new(argv).parse
      end

      def initialize(argv)
        @argv = argv
      end

      def parse
        slop.parse(@argv)
        slop.to_hash
      end

      private

      def slop
        @slop ||= Slop.new(:help => true) do
          banner "Usage: guidline [directory] [options]"
          on :c=, :config=, "path to config YAML file"
        end
      end
    end
  end
end
