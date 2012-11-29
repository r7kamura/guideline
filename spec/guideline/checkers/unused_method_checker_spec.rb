require "spec_helper"

module Guideline
  describe UnusedMethodChecker do
    let(:checker) do
      described_class.new
    end

    let(:path) do
      mock(:read => script, :to_s => "mock.rb")
    end

    describe "#prepare" do
      let(:script) do
        <<-EOF
          a
          b()
          d.c
          f.e()
        EOF
      end

      it "remembers method calls" do
        checker.prepare(path)
        checker.send(:calls).should == %w[a b c d e f]
      end
    end

    describe "#check" do
      before do
        checker.instance_variable_set(:@calls, %w[a b])
      end

      let(:script) do
        <<-EOF
          def a
            1
          end

          def b
            2
          end

          def c
            3
          end
        EOF
      end

      it "remembers method definitions" do
        checker.stub(:clear_definitions)
        checker.check(path)
        checker.send(:definitions).map(&:name).should == %w[a b c]
      end

      it "detects unused method definitions" do
        checker.stub(:clear_definitions)
        checker.check(path)
        checker.send(:unused_methods).map(&:name).should == %w[c]
      end

      it "reports unused method definitions" do
        checker.should_receive(:report)
        checker.check(path)
      end

      it "clears up its definitions after check" do
        checker.check(path)
        checker.send(:definitions).should be_empty
      end
    end
  end
end
