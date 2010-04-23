require 'helper'

class TestStartedCheck < Test::Unit::TestCase

  def set_check(options = {})
    @check = Spex::StartedCheck.new('testproc', options)
  end

  context "Started Check" do
    context "instances" do
      context "set to true" do
        setup do
          set_check(true)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          should "fail" do
            check_fails_before
          end
        end
        context "process not running before execution" do
          context "process running after execution" do
            should "pass" do
              check_passes { start_process! }
            end
          end
          context "process not running after execution" do
            should 'fail' do
              check_fails
            end
          end
        end
      end
      context "set to false" do
        setup do
          set_check(false)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          should "fail" do
            check_fails_before
          end
        end
        context "process not running before execution" do
          context "but process running after execution" do
            should "fail" do
              check_fails { start_process! }
            end
          end
          context "but process not running after execution" do
            should 'pass' do
              check_passes
            end
          end
        end
      end
    end
  end
end
