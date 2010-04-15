require 'helper'

class TestRestartedAssertion < Test::Unit::TestCase

  def set_assertion(options = {})
    @assertion = Spex::RestartedAssertion.new('testproc', options)
  end

  context "Restarted Assertion" do
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
            context "with the same pid" do
              should 'fail' do
                assertion_fails
              end
            end
            context "with a different pid" do
              should 'pass' do
                assertion_passes { start_process!('101') }
              end
            end
          end
          context "but process not running after execution" do
            should "fail" do
              assertion_fails
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
            context "with the same pid" do
              should 'pass' do
                assertion_passes
              end
            end
            context "with a different pid" do
              should 'fail' do
                assertion_fails { start_process!('101') }
              end
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
