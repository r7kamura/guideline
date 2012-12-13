require "pathname"

module Guideline
  class PathFinder
    def self.find(pattern)
      new(pattern).paths
    end

    def initialize(pattern)
      @pattern = pattern
    end

    def paths
      Pathname.glob(recognized_pattern)
    end

    private

    def pattern
      @pattern
    end

    def path
      @path ||= Pathname.new(pattern)
    end

    def recognized_pattern
      case
      when pattern_not_given?
        default_glob
      when directory?
        default_glob_with_directory
      else
        pattern
      end
    end

    def pattern_not_given?
      pattern.nil?
    end

    def directory?
      path.directory?
    end

    def default_glob
      "**/*.rb"
    end

    def default_glob_with_directory
      File.join(path, default_glob)
    end
  end
end
