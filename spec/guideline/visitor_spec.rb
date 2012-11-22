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

    describe "#check" do
      subject do
        visitor.check
      end

      it "calls checker#check with matched path" do
        checker.should_receive(:check).with(path)
        subject
      end
    end
  end
end
