require "spec_helper"

module Guideline
  describe TrailingWhitespaceChecker do
    describe "#check" do
      let(:checker) do
        described_class.new
      end

      let(:path) do
        mock(:each_line => script.each_line)
      end

      context "when there is trailing whitespace" do
        let(:script) do
          <<-EOF
            1 
          EOF
        end

        it "detects error" do
          checker.check(path)
          checker.should have_error
        end
      end

      context "when there is no trailing whitespace" do
        let(:script) do
          <<-EOF
            1
          EOF
        end

        it "does not detect error" do
          checker.check(path)
          checker.should_not have_error
        end
      end
    end
  end
end
