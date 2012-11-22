require "spec_helper"

module Guideline
  describe LongLineChecker do
    describe "#check" do
      subject do
        checker.check(path)
      end

      let(:checker) do
        described_class.new(:max => 1)
      end

      let(:path) do
        Pathname.new(__FILE__)
      end

      it do
        should be_a Array
      end

      it do
        subject
        checker.should have_error
      end
    end
  end
end
