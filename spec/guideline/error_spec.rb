require "spec_helper"

module Guideline
  describe Error do
    let(:error) do
      described_class.new(:line => 1, :message => "message")
    end

    describe "#render" do
      it "renders its line and message" do
        error.should_receive(:puts).with("   1: message")
        error.render
      end
    end
  end
end
