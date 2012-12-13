require "pathname"

module Guideline
  class Renderer
    def initialize(errors)
      @errors = errors
    end

    def detail
      "".tap do |result|
        errors_by_path.each do |path, errors|
          result << "\n#{path}\n"
          errors.sort_by(&:line).each {|error| result << "#{error.render}\n" }
        end
      end
    end

    def summary
      "".tap do |result|
        error_summary.each do |name, count|
          result << "#{name}: #{count}\n"
        end
      end
    end

    private

    def errors_by_path
      errors.group_by(&:path)
    end

    def error_summary
      errors.inject(summary_hash) do |hash, error|
        hash[error.name] += 1
        hash
      end
    end

    def errors
      @errors
    end

    def summary_hash
      Hash.new {|hash, key| hash[key] = 0 }
    end
  end
end
