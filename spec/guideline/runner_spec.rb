require "spec_helper"

module Guideline
  describe Runner do
    describe ".parse" do
      subject do
        described_class.parse(argv)
      end

      let(:argv) do
        []
      end

      it { should be_a HashWithIndifferentAccess }

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
