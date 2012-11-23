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
        checkers[0].should be_a LongLineChecker
        checkers[1].should be_a LongMethodChecker
        checkers[0].send(:max).should == 80
        checkers[1].send(:max).should == 10
      end
    end
  end
end
