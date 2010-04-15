require 'helper'

class TestStoppedAssertion < Test::Unit::TestCase

  def set_assertion(options = {})
    @assertion = Spex::StoppedAssertion.new('testproc', options)
  end

  context "Stopped Assertion" do
    context "instances" do
      context "set to true" do
        setup do
          set_assertion(true)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          context "and process running after execution" do
            should 'fail' do
              assertion_fails
            end
          end
          context "but process not running after execution" do
            should "pass" do
              assertion_passes { stop_process! }
            end
          end
        end
        context "process not running before execution" do
          should "fail" do
            assertion_fails_before
          end
        end
      end
      context "set to false" do
        setup do
          set_assertion(false)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          context "and process running after execution" do
            should 'pass' do
              assertion_passes
            end
          end
          context "but process not running after execution" do
            should "fail" do
              assertion_fails { stop_process! }
            end
          end
        end
        context "process not running before execution" do
          should "fail" do
            assertion_fails_before
          end
        end
      end
    end
  end
end
