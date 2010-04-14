require 'helper'

class TestAssertion < Test::Unit::TestCase

  def set_assertion(options = {})
    @assertion = Spex::ModifiedAssertion.new(@filename, options)
  end

  def non_blank_file!(text = 'test')
    File.open(@filename, 'w') { |f| f.puts text }
  end

  def blank_file!
    File.open(@filename, 'w') { |f| f.puts }
  end
  
  context "Modified Assertion" do
    setup do
      FakeFS.activate!
      @filename = '/tmp/modified-test'
    end

    teardown do
      FakeFS.deactivate!
    end

    context "instances" do
      context "without options" do
        setup do
          set_assertion
          blank_file!
        end
        should "pass when modifications happen" do
          assertion_passes { non_blank_file! }
        end
        should "when modifications don't happen" do
          assertion_fails
        end
      end
      context "with :added" do
        context "as a string" do
          setup do
            set_assertion(:added => 'test')
            blank_file!
          end
          context "when the text is added" do
            should "pass" do
              assertion_passes { non_blank_file! }
            end
          end
          context "when different text is added" do
            should "fail" do
              assertion_fails { non_blank_file!('other') }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              assertion_fails
            end
          end
        end
        context "as a regexp" do
          setup do
            set_assertion(:added => /t.st/)
            blank_file!
          end
          context "when the text is added" do
            should "pass" do
              assertion_passes { non_blank_file! }
            end
          end
          context "when different text is added" do
            should "fail" do
              assertion_fails { non_blank_file!('other') }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              assertion_fails
            end
          end
        end
      end
      context "with :removed" do
        context "as a string" do
          setup do
            set_assertion(:removed => 'test')
          end
          context "when the text is removed" do
            setup do
              non_blank_file!
            end
            should "pass" do
              assertion_passes { blank_file! }
            end
          end
          context "when different text is removed" do
            setup do
              non_blank_file!('other')
            end
            should "fail" do
              assertion_fails { blank_file! }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              assertion_fails
            end
          end
        end
        context "as a regexp" do
          setup do
            set_assertion(:removed => /t.st/)
          end
          context "when the text is removed" do
            setup do
              non_blank_file!
            end
            should "pass" do
              assertion_passes { blank_file! }
            end
          end
          context "when different text is removed" do
            setup do
              non_blank_file!('other')
            end
            should "fail" do
              assertion_fails { blank_file! }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              assertion_fails
            end
          end
        end
      end
    end
  end
end
