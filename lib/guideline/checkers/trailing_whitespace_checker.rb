module Guideline
  class TrailingWhitespaceChecker < Checker
    def check(path)
      path.each_line.with_index do |line, index|
        if line =~ / $/
          report(
            :message => "Remove trailing whitespace",
            :path    => path,
            :line    => index + 1
          )
        end
      end
    end
  end
end
