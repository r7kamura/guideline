require "yaml"
require "slop"
require "active_support/core_ext/hash/indifferent_access"

module Guideline
  class Runner
    def self.parse(*argv)
      new(*argv).parse
    end

    def initialize(argv)
      @hash = Parser.parse(argv).with_indifferent_access
    end

    def parse
      @hash[:config] = load_config
      @hash.delete(:help)
      @hash
    end

    private

    def load_config
      YAML.load_file(config_path)
    rescue Errno::ENOENT
      raise "No such config file - #{config_path}"
    end

    def config_path
      @hash[:config] || default_config_path
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
          banner "Usage: guideline [directory] [options]"
          on :c=, :config=, "Path to config YAML file"
        end
      end
    end
  end
end
