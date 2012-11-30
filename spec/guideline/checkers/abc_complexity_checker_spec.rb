require "spec_helper"

module Guideline
  describe AbcComplexityChecker do
    describe "#check" do
      subject do
        checker.check(path)
        checker
      end

      let(:checker) do
        described_class.new(:max => 1.4)
      end

      let(:path) do
        mock(:read => script, :to_s => "mock.rb")
      end

      context "when there is a few assignment" do
        let(:script) do
          <<-EOF
            def a
              b = 1
            end
          EOF
        end
        it { should_not have_error }
      end

      context "when there is too much assign" do
        let(:script) do
          <<-EOF
            def a
              b = 1
              c = 2
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much opassign" do
        let(:script) do
          <<-EOF
            def a
              b += 1
              c += 1
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much else statement" do
        let(:script) do
          <<-EOF
            def a
              if b
                1
              else
                2
              end

              if c
                3
              else
                4
              end
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much comparison operator" do
        let(:script) do
          <<-EOF
            def a
              b == 1
              c == 2
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much fcall" do
        let(:script) do
          <<-EOF
            def a
              b()
              c()
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much vcall" do
        let(:script) do
          <<-EOF
            def a
              b
              c
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much call and vcall" do
        let(:script) do
          <<-EOF
            def a
              b.c
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much vcall and do_block" do
        let(:script) do
          <<-EOF
            def a
              a do
                1
              end
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much vcall and brace_block" do
        let(:script) do
          <<-EOF
            def a
              a { 1 }
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much yield" do
        let(:script) do
          <<-EOF
            def a
              yield
              yield
            end
          EOF
        end
        it { should have_error }
      end

      context "when there is too much super" do
        let(:script) do
          <<-EOF
            def a
              super
              super
            end
          EOF
        end
        it { should have_error }
      end
    end
  end
end
