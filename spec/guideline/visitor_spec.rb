require "spec_helper"

module Guideline
  describe Visitor do
    before do
      visitor.stub(:paths).and_return(paths)
    end

    let(:visitor) do
      described_class.new(:checker => [checker])
    end

    let(:checker) do
      mock(:has_error? => false)
    end

    let(:paths) do
      [path]
    end

    let(:path) do
      mock
    end

    describe "#visit" do
      it "calls checker#check with path" do
        checker.should_receive(:check).with(path)
        visitor.visit
      end
    end

    describe "#prepare" do
      context "if checker can respond to #prepare" do
        before do
          checker.stub(:respond_to?).with(:prepare).and_return(true)
        end

        it "calls checker#prepare with path" do
          checker.should_receive(:prepare).with(path)
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
