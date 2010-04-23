module Spex
  class StoppedCheck < ProcessCheck
    as :stopped, 'process stop'
    example "Process was stopped", "check 'postfix', :stopped => true"
    example "Process was not stopped", "check 'postfix', :stopped => false"

    def before
      assert current_pid, "Process '#{target}' is not running (will not be stopped)"
    end

    def after
      pid = current_pid
      if active?
        assert_nil pid, "Process '#{target}' is still running (pid #{pid})"
      else
        assert_not_nil pid, "Process '#{target}' was stopped"
      end
    end
  end
end
