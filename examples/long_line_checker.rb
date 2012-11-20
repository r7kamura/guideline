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

__END__
app/controllers/blogs_controller.rb
   8: Line length 169 should be less than 128 characters

app/models/blog.rb
   4: Line length 169 should be less than 128 characters

spec/controllers/blogs_controller_spec.rb
   6: Line length 139 should be less than 128 characters
  10: Line length 194 should be less than 128 characters
  16: Line length 145 should be less than 128 characters
  17: Line length 139 should be less than 128 characters
  21: Line length 194 should be less than 128 characters
