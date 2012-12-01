require "spec_helper"

module Guideline
  describe Runner do
    describe ".parse" do
      subject do
        described_class.parse(argv)
      end

      before do
        described_class.any_instance.stub(:puts)
      end

      let(:argv) do
        []
      end

      it { should be_a HashWithIndifferentAccess }

      context "when given --init option" do
        let(:argv) do
          ["--init"]
        end

        context "when config file already exists" do
          before do
            described_class.any_instance.stub(:config_file_exist? => true)
          end

          it "does not generate config file" do
            FileUtils.should_not_receive(:copy)
            expect { subject }.to raise_error(SystemExit)
          end
        end

        context "when config file does not exist" do
          before do
            described_class.any_instance.stub(:config_file_exist? => false)
          end

          it "generates config file" do
            FileUtils.should_receive(:copy)
            expect { subject }.to raise_error(SystemExit)
          end
        end
      end

      context "when not given --config option" do
        it "returns default config parsed from guideline.yml" do
          should == {
            "config" => {
              "Guideline::LongLineChecker" => {
                "max" => 80,
              },
              "Guideline::LongMethodChecker" => {
                "max" => 10,
              },
              "Guideline::AbcComplexityChecker" => {
                "max" => 10,
              },
            },
            "init" => nil,
            "version" => nil,
          }
        end
      end

      context "when existent file is specified by --config option" do
        let(:argv) do
          ["--config", "existent.yml"]
        end

        before do
          YAML.stub(:load_file).and_return("a" => "b")
        end

        it "returns config parsed from specified file" do
          should == {
            "config" => {
              "a" => "b",
            },
            "init" => nil,
            "version" => nil,
          }
        end
      end

      context "when non-existent file is specified by --config option" do
        let(:argv) do
          ["--config", "non-existent.yml"]
        end

        it do
          expect { subject }.to raise_error
        end
      end
    end
  end
end
