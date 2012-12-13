require "spec_helper"

module Guideline
  describe Renderer do
    let(:renderer) do
      described_class.new(errors)
    end

    let(:errors) do
      [error]
    end

    let(:error) do
      mock(
        :line   => 1,
        :path   => "path",
        :render => "rendered",
        :name   => "name"
      )
    end

    describe "#detail" do
      subject do
        renderer.detail
      end

      it { should == "\npath\nrendered\n" }
    end

    describe "#summary" do
      subject do
        renderer.summary
      end

      it { should == "name: 1\n" }
    end
  end
end
