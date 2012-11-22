require "spec_helper"

module Guideline
  describe Checker do
    let(:instance) do
      described_class.new(options)
    end

    let(:options) do
      mock
    end

    let(:error) do
      {
        :message => "message",
        :path    => "path",
        :line    => "line",
      }
    end

    describe "#errors" do
      subject do
        instance.errors
      end

      it "returns an Array" do
        should be_a Array
      end
    end

    describe "#report" do
      it "adds error record into its errors" do
        instance.report(error)
        instance.errors.first.message.should == "message"
      end
    end

    describe "#has_error?" do
      subject do
        instance.has_error?
      end

      context "when its errors is empty" do
        it { should be_false }
      end

      context "when its errors is not empty" do
        before do
          instance.report(error)
        end

        it { should be_true }
      end
    end
  end
end
