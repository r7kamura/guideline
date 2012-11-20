#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "guideline"

checker = Guideline::LongLineChecker.new(:max => 128)
visitor = Guideline::Visitor.new(:checker => checker)
errors  = visitor.check
errors.group_by(&:path).each do |path, error_set|
  puts path
  error_set.each do |error|
    puts "%4d: %s" % [error.line, error.message]
  end
  puts
end
