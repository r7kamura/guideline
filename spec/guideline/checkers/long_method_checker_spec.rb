require "spec_helper"

module Guideline
  describe LongMethodChecker do
    describe "#check" do
      let(:checker) do
        described_class.new(:max => 1)
      end

      let(:path) do
        mock(:read => script)
      end

      context "when there is too long method" do
        let(:script) do
          <<-EOF
            def foo
              1
              2
            end
          EOF
        end

        it "detects error" do
          checker.check(path)
          checker.should have_error
        end
      end

      context "when there is no too long method" do
        let(:script) do
          <<-EOF
            def foo
              1
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
