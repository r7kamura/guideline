require "spec_helper"

module Guideline
  describe Visitor do
    let(:visitor) do
      described_class.new(options)
    end

    let(:options) do
      { :checker => [checker] }
    end

    let(:checker) do
      mock(:has_error? => false)
    end

    describe "#visit" do
      let(:path) do
        Pathname.new("spec/guideline/visitor_spec.rb")
      end

      context "when :only option is not specified" do
        it "visits all paths" do
          called = false
          checker.should_receive(:check).at_least(1) do |args|
            called = true if args == path
          end
          visitor.visit
          called.should be_true
        end
      end

      context "when :only option is specified" do
        before do
          options[:only] = "lib/**/*.rb"
        end

        it "does not visit paths which are not specified" do
          checker.should_not_receive(:check).with(path)
          visitor.visit
        end
      end

      context "when :except option is specified" do
        before do
          options[:except] = "spec/**/*.rb"
        end

        it "does not visit paths which are specified" do
          checker.should_not_receive(:check).with(path)
          visitor.visit
        end
      end
    end

    describe "#prepare" do
      context "if checker can respond to #prepare" do
        before do
          checker.stub(:respond_to?).with(:prepare).and_return(true)
        end

        it "calls checker#prepare with path" do
          checker.should_receive(:prepare).at_least(1)
          visitor.prepare
        end
      end

      context "if checker cannot respond to #prepare" do
        before do
          checker.stub(:respond_to?).with(:prepare).and_return(false)
        end

        it "does not call checker#prepare with path" do
          checker.should_not_receive(:prepare)
          visitor.prepare
        end
      end
    end

    describe "#render" do
      before do
        visitor.instance_variable_set(:@errors, errors)
        visitor.stub(:puts)
      end

      let(:errors) do
        [error]
      end

      let(:error) do
        mock(:path => "path")
      end

      it "calls #render of each error" do
        error.should_receive(:render)
        visitor.render
      end
    end
  end
end
