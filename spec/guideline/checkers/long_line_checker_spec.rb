require "spec_helper"

module Guideline
  describe LongLineChecker do
    describe "#check" do
      let(:checker) do
        described_class.new(:max => 50)
      end

      let(:path) do
        mock(:each_line => content.each_line)
      end

      context "when there is too line" do
        let(:content) do
          <<-EOF
            def foo
              too looooooooooooooooooooooooooooooooooooooooooooooooooooong line
            end
          EOF
        end

        specify "checker detects error" do
          checker.check(path)
          checker.should have_error
        end
      end

      context "when there is no too long line" do
        let(:content) do
          <<-EOF
            def foo
              not long line
            end
          EOF
        end

        specify "checker does not detect error" do
          checker.check(path)
          checker.should_not have_error
        end
      end
    end
  end
end
