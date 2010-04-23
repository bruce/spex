require 'helper'

class TestRestartedCheck < Test::Unit::TestCase

  def set_check(options = {})
    @check = Spex::RestartedCheck.new('testproc', options)
  end

  context "Restarted Check" do
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
            context "with the same pid" do
              should 'fail' do
                check_fails
              end
            end
            context "with a different pid" do
              should 'pass' do
                check_passes { start_process!('101') }
              end
            end
          end
          context "but process not running after execution" do
            should "fail" do
              check_fails
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
            context "with the same pid" do
              should 'pass' do
                check_passes
              end
            end
            context "with a different pid" do
              should 'fail' do
                check_fails { start_process!('101') }
              end
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
