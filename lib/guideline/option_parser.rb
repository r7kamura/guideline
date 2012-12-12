require "optparse"

module Guideline
  class OptionParser < ::OptionParser
    OPTIONS = [
      "--no-abc-complexity",      "(default: true) check method ABC complexity",
      "--no-hard-tab-indent",     "(default: true) check hard tab indent",
      "--no-hash-comma",          "(default: true) check last comma in Hash literal",
      "--no-long-line",           "(default: true) check line length",
      "--no-long-method",         "(default: true) check method height",
      "--no-trailing-whitespace", "(default: true) check trailing whitespace",
      "--no-unused-method",       "(default: true) check unused method",
      "--abc-complexity=",        "(default:   15) threshold of ABC complexity",
      "--long-line=",             "(default:   80) threshold of long line",
      "--long-method=",           "(default:   10) threshold of long method",
      "--path=",                  "(default:   ./) checked file or dir or glob pattern",
    ]

    def self.parse(argv = ARGV)
      new.parse(argv)
    end

    def initialize(*)
      super
      configure_checker_options
    end

    def parse(*)
      super
      options
    end

    def options
      @options ||= {}
    end

    private

    def configure_checker_options
      arguments.each do |argument|
        on(argument.key, argument.description) do |value|
          options[argument.to_sym] = value
        end
      end
    end

    def arguments
      OPTIONS.each_slice(2).map do |key, description|
        Argument.new(key, description)
      end
    end

    class Argument
      attr_reader :key, :description

      def initialize(key, description)
        @key         = key
        @description = description
      end

      def to_sym
        str = @key
        str = without_head_hyphen(str)
        str = without_head_no(str)
        str = without_last_equal(str)
        str = underscored(str)
        str.to_sym
      end

      private

      def underscored(str)
        str.gsub("-", "_")
      end

      def without_head_hyphen(str)
        str.gsub(/^--/, "")
      end

      def without_head_no(str)
        str.gsub(/^no-/, "")
      end

      def without_last_equal(str)
        str.gsub(/=$/, "")
      end
    end
  end
end
