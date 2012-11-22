module Guideline
  class HardTabIndentChecker < Checker
    def check(path)
      path.each_line.with_index do |line, index|
        if line =~ /^ *\t/
          report(
            :message => "Use space indent instead of hard tab indent",
            :path    => path,
            :line    => index + 1
          )
        end
      end
    end
  end
end
