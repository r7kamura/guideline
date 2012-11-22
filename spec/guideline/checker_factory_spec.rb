require "spec_helper"

module Guideline
  describe CheckerFactory do
    describe "#create" do
      subject do
        described_class.new(
          {
            "Guideline::LongLineChecker" => { :max => 80 },
            "Guideline::LongMethodChecker" => { :max => 10 },
          },
          LongLineChecker,
          LongMethodChecker,
        ).create
      end

      let(:checkers) do
        subject
      end

      it "creates instances of given classes with given config" do
        LongLineChecker.should_receive(:new).with(:max => 80).and_call_original
        LongMethodChecker.should_receive(:new).with(:max => 10).and_call_original
        checkers[0].should be_a LongLineChecker
        checkers[1].should be_a LongMethodChecker
      end
    end
  end
end
