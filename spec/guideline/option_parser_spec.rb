require "spec_helper"

module Guideline
  describe OptionParser do
    describe ".parse" do
      subject do
        described_class.parse(argv)
      end

      context "when ARGV is --no-abc-complexity" do
        let(:argv) do
          ["--no-abc-complexity"]
        end
        it { should == { :abc_complexity => false } }
      end

      context "when ARGV is --abc-complexity 5" do
        let(:argv) do
          ["--abc-complexity", "5"]
        end
        it { should == { :abc_complexity => "5" } }
      end

      context "when ARGV is --non-existent-key" do
        let(:argv) do
          ["--non-existent-key"]
        end
        it do
          expect { subject }.to raise_error
        end
      end
    end
  end
end
