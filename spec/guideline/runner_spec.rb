require "spec_helper"

module Guideline
  describe Runner do
    describe ".parse" do
      subject do
        described_class.parse(argv)
      end

      before do
        YAML.stub(:load_file).and_return(config)
      end

      let(:config) do
        { "a" => 1 }
      end

      let(:path) do
        File.expand_path("../../../guideline.yml", __FILE__)
      end

      let(:argv) do
        ["--config", path]
      end

      it "loads config option as YAML path" do
        YAML.should_receive(:load_file).with(path)
        subject
      end

      it "returns config option as HashWithIndifferentAccess" do
        subject[:config].should be_a HashWithIndifferentAccess
      end

      context "when config option is passed" do
        it "returns parsed options" do
          should == { :config => config }
        end
      end

      context "when config option is passed in short version" do
        let(:argv) do
          ["-c", path]
        end

        it "returns parsed options" do
          should == { :config => config }
        end
      end

      context "when config option is not passed" do
        let(:argv) do
          []
        end

        it "returns parsed options with default config path" do
          described_class.should_receive(:default_config_path)
          should have_key(:config)
        end
      end
    end
  end
end
