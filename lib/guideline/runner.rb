require "yaml"
require "fileutils"
require "slop"
require "active_support/core_ext/hash/indifferent_access"

module Guideline
  class Runner
    CONFIG_FILE_NAME = ".guideline.yml"

    def self.parse(*argv)
      new(*argv).parse
    end

    def initialize(argv)
      @hash = Parser.parse(argv).with_indifferent_access
    end

    def parse
      before_hook
      @hash[:config] = load_config
      @hash.delete(:help)
      @hash
    end

    private

    def before_hook
      case
      when @hash[:init]
        generate_default_config_file
      when @hash[:version]
        show_version
      end
    end

    def show_version
      puts VERSION
      exit
    end

    def load_config
      YAML.load_file(config_path)
    rescue Errno::ENOENT
      puts "No such config file - #{config_path}"
      exit
    end

    def config_path
      @hash[:config] || default_config_path
    end

    def default_config_path
      File.expand_path("../../../#{CONFIG_FILE_NAME}", __FILE__)
    end

    def generate_default_config_file
      if config_file_exist?
        puts "./#{CONFIG_FILE_NAME} already exists"
      else
        FileUtils.copy(default_config_path, "./")
        puts "./#{CONFIG_FILE_NAME} was generated"
      end
      exit
    end

    def config_file_exist?
      File.exist?(CONFIG_FILE_NAME)
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
          on :c=, :config=, "Path to config YAML file."
          on :i, :init, "Generate config YAML template into current directory."
          on :v, :version, "Show version number"
        end
      end
    end
  end
end
