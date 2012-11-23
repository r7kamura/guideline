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
      it "calls checker#check with matched path" do
        checker.should_receive(:check).with(path)
        visitor.visit
      end
    end
  end
end
