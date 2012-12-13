require "spec_helper"

module Guideline
  describe Runner do
    let(:runner) do
      described_class.new
    end

    describe ".run" do
      it "creates its instance and call #run" do
        described_class.any_instance.should_receive(:run)
        described_class.run
      end
    end

    describe "#run" do
      before do
        runner.stub(:enable_checkers => enable_checkers)
      end

      let(:enable_checkers) do
        [checker]
      end

      let(:checker) do
        mock(:has_error? => false)
      end

      it "runs enable checkers" do
        checker.should_receive(:check).at_least(1)
        runner.run
      end
    end

    describe "#enable_checkers" do
      subject do
        runner.send(:enable_checkers)
      end

      before do
        runner.stub(:options => options)
      end

      context "when options[:abc_complexity] is false" do
        let(:options) do
          { :abc_complexity => false }
        end

        it "does not include AbcComplexityChecker" do
          should_not be_any {|checker| checker.is_a?(AbcComplexityChecker) }
        end
      end

      context "when options[:abc_complexity] is nil" do
        let(:options) do
          {}
        end

        it "includes AbcComplexityChecker" do
          should be_any {|checker| checker.is_a?(AbcComplexityChecker) }
        end
      end
    end
  end
end
