require "spec_helper"

module Guideline
  describe Visitor do
    let(:visitor) do
      described_class.new(pattern, checkers)
    end

    let(:pattern) do
      nil
    end

    let(:checkers) do
      [checker]
    end

    let(:checker) do
      mock(:has_error? => false)
    end

    describe "#visit" do
      let(:path) do
        Pathname.new(__FILE__)
      end

      let(:pattern) do
        path.to_s
      end

      it "calls checker.check with found paths" do
        checker.should_receive(:check).with(path).at_least(1)
        visitor.visit
      end
    end

    describe "#prepare" do
      context "if checker can respond to #prepare" do
        before do
          checker.stub(:respond_to?).with(:prepare).and_return(true)
        end

        it "calls checker#prepare with path" do
          checker.should_receive(:prepare).at_least(1)
          visitor.prepare
        end
      end

      context "if checker cannot respond to #prepare" do
        before do
          checker.stub(:respond_to?).with(:prepare).and_return(false)
        end

        it "does not call checker#prepare with path" do
          checker.should_not_receive(:prepare)
          visitor.prepare
        end
      end
    end
  end
end
