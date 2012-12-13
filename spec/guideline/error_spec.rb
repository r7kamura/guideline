require "spec_helper"

module Guideline
  describe Error do
    let(:error) do
      described_class.new(:line => 1, :type => :type, :message => "message")
    end

    describe "#render" do
      subject do
        error.render
      end

      it "return string including its line and message" do
        should == "   1: message"
      end
    end
  end
end
