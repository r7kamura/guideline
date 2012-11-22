require "ostruct"

module Guideline
  class Error < OpenStruct
    def render
      puts "%4d: %s" % [line, message]
    end
  end
end
