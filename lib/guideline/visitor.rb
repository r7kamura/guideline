require "pathname"

module Guideline
  class Visitor
    attr_reader :options

    def initialize(pattern, checkers)
      @pattern  = pattern
      @checkers = checkers
    end

    def visit
      paths.each do |path|
        checkers.each do |checker|
          checker.check(path)
        end
      end
    end

    def prepare
      paths.each do |path|
        checkers.each do |checker|
          checker.prepare(path) if checker.respond_to?(:prepare)
        end
      end
    end

    def errors
      @errors ||= checkers.select(&:has_error?).map(&:errors).inject([], &:+)
    end

    private

    def paths
      PathFinder.find(pattern)
    end

    def checkers
      @checkers
    end

    def pattern
      @pattern
    end
  end
end
