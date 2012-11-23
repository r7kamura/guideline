require "spec_helper"

module Guideline
  describe Runner do
    describe ".parse" do
      subject do
        described_class.parse(argv)
      end

      let(:path) do
        File.expand_path("../../../guideline.yml", __FILE__)
      end

      context "when config option is passed" do
        let(:argv) do
          ["--config", path]
        end

        it "parses ARGV and returns options with config hash" do
          should have_key(:config)
        end
      end

      context "when config option is passed in short version" do
        let(:argv) do
          ["-c", path]
        end

        it "parses ARGV and returns options with config hash" do
          should have_key(:config)
        end
      end

      context "when config option is not passed" do
        let(:argv) do
          []
        end

        it "parses ARGV and returns options with config hash" do
          should have_key(:config)
        end
      end

      context "when config option is wrong" do
        let(:argv) do
          ["--config", "wrong config path"]
        end

        it do
          expect { subject }.to raise_error(StandardError)
        end
      end
    end
  end
end
