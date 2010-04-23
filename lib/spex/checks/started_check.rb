module Spex
  class StartedCheck < ProcessCheck
    as :started, 'process start'
    example "Process was started", "check 'postfix', :started => true"
    example "Process was not started", "check 'postfix', :started => false"

    def before
      pid = current_pid
      assert !pid, "Process '#{target}' is already running (pid #{pid})"
    end

    def after
      if active?
        assert current_pid, "Process '#{target}' was not started"
      else
        pid = current_pid
        assert_nil pid, "Process '#{target}' was started (pid #{pid})"
      end
    end
  end
end
