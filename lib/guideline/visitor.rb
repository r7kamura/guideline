require "pathname"
require "active_support/all"

module Guideline
  class Visitor
    attr_reader :options

    def initialize(options, &block)
      @options = options
      @block   = block
    end

    def check
      travel
      errors
    end

    def render
      errors.group_by(&:path).each do |path, errors|
        puts path
        errors.each(&:render)
        puts
      end
    end

    private

    def travel
      paths.each do |path|
        checkers.each do |checker|
          checker.check(path)
        end
      end
    end

    def paths
      PathFinder.find(options)
    end

    def checkers
      @checkers ||= Array(options[:checker])
    end

    def errors
      @errors ||= checkers.select(&:has_error?).map(&:errors).inject([], &:+)
    end

    class PathFinder
      attr_reader :options

      def self.find(options = {})
        new(options).paths
      end

      def initialize(options = {})
        @options = options
      end

      def paths
        (found_paths - excepted_paths).select(&:exist?)
      end

      private

      def found_paths
        search_paths(options[:only] || "**/*.rb")
      end

      def excepted_paths
        search_paths(options[:except])
      end

      def search_paths(patterns)
        Array(patterns).inject([]) do |paths, pattern|
          paths + Pathname.glob(pattern)
        end
      end
    end
  end
end
