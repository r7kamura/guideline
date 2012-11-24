require "spec_helper"

module Guideline
  describe HashCommaChecker do
    describe "#check" do
      subject do
        checker.check(path)
        checker
      end

      let(:checker) do
        described_class.new
      end

      let(:path) do
        mock(:read => script)
      end

      context "when there is no last comma in sigleline hash" do
        let(:script) do
          <<-EOF
            { :a => 1 }
          EOF
        end

        it "does not detect error" do
          should_not have_error
        end
      end

      context "when there is last comma in sigleline hash" do
        let(:script) do
          <<-EOF
            { :a => 1, }
          EOF
        end

        it "does not detect error" do
          should_not have_error
        end
      end

      context "when there is no last comma in multiline hash" do
        let(:script) do
          <<-EOF
            {
              :a => 1
            }
          EOF
        end

        it "detects error" do
          should have_error
        end
      end

      context "when there is no last comma in multiline hash of new syntax" do
        let(:script) do
          <<-EOF
            {
              a: 1
            }
          EOF
        end

        it "detects error" do
          should have_error
        end
      end

      context "when there is no last comma in multiline hash with array" do
        let(:script) do
          <<-EOF
            {
              :a => [1, 2, 3]
            }
          EOF
        end

        it "detects error" do
          should have_error
        end
      end

      context "when there is last comma in multiline hash" do
        let(:script) do
          <<-EOF
            {
              :a => 1,
            }
          EOF
        end

        it "does not detect error" do
          should_not have_error
        end
      end

      context "when there is no last comma in multiline nested hash" do
        let(:script) do
          <<-EOF
            {
              :a => {
                :b => 1,
              }
            }
          EOF
        end

        it "detects error" do
          should have_error
        end
      end
    end
  end
end
