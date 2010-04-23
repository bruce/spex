require 'helper'

class TestStoppedCheck < Test::Unit::TestCase

  def set_check(options = {})
    @check = Spex::StoppedCheck.new('testproc', options)
  end

  context "Stopped Check" do
    context "instances" do
      context "set to true" do
        setup do
          set_check(true)
        end
        context "process running before execution" do
          setup do
            start_process!
          end
          context "and process running after execution" do
            should 'fail' do
              check_fails
            end
          end
          context "but process not running after execution" do
            should "pass" do
              check_passes { stop_process! }
            end
          end
        end
        context "process not running before execution" do
          should "fail" do
            check_fails_before
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
          context "and process running after execution" do
            should 'pass' do
              check_passes
            end
          end
          context "but process not running after execution" do
            should "fail" do
              check_fails { stop_process! }
            end
          end
        end
        context "process not running before execution" do
          should "fail" do
            check_fails_before
          end
        end
      end
    end
  end
end
