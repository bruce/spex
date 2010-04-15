require 'helper'

class TestStartedAssertion < Test::Unit::TestCase

  def set_assertion(options = {})
    @assertion = Spex::StartedAssertion.new('testproc', options)
  end

  context "Started Assertion" do
    context "instances" do
      context "set to true" do
        setup do
          set_assertion(true)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          should "fail" do
            assertion_fails_before
          end
        end
        context "process not running before execution" do
          context "process running after execution" do
            should "pass" do
              assertion_passes { start_process! }
            end
          end
          context "process not running after execution" do
            should 'fail' do
              assertion_fails
            end
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
          should "fail" do
            assertion_fails_before
          end
        end
        context "process not running before execution" do
          context "but process running after execution" do
            should "fail" do
              assertion_fails { start_process! }
            end
          end
          context "but process not running after execution" do
            should 'pass' do
              assertion_passes
            end
          end
        end
      end
    end
  end
end
