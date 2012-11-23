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
        mock(:read => content)
      end

      context "when there is no last comma in sigleline hash" do
        let(:content) do
          <<-EOF
            { :a => 1 }
          EOF
        end

        specify "checker does not detect error" do
          should_not have_error
        end
      end

      context "when there is last comma in sigleline hash" do
        let(:content) do
          <<-EOF
            { :a => 1, }
          EOF
        end

        specify "checker does not detect error" do
          should_not have_error
        end
      end

      context "when there is no last comma in multiline hash" do
        let(:content) do
          <<-EOF
            {
              :a => 1
            }
          EOF
        end

        specify "checker detects error" do
          should have_error
        end
      end

      context "when there is no last comma in multiline hash with array" do
        let(:content) do
          <<-EOF
            {
              :a => [1, 2, 3]
            }
          EOF
        end

        specify "checker detects error" do
          should have_error
        end
      end

      context "when there is last comma in multiline hash" do
        let(:content) do
          <<-EOF
            {
              :a => 1,
            }
          EOF
        end

        specify "checker does not detect error" do
          should_not have_error
        end
      end

      context "when there is no last comma in multiline nested hash" do
        let(:content) do
          <<-EOF
            {
              :a => {
                :b => 1,
              }
            }
          EOF
        end

        specify "checker detects error" do
          should have_error
        end
      end
    end
  end
end
