require "spec_helper"

module Guideline
  describe LongLineChecker do
    describe "#check" do
      let(:checker) do
        described_class.new(:max => 50)
      end

      let(:path) do
        mock(:each_line => script.each_line)
      end

      context "when there is too line" do
        let(:script) do
          <<-EOF
            def foo
              too looooooooooooooooooooooooong line
            end
          EOF
        end

        it "detects error" do
          checker.check(path)
          checker.should have_error
        end
      end

      context "when there is no too long line" do
        let(:script) do
          <<-EOF
            def foo
              not loooooooooooooooooooooooong line
            end
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
