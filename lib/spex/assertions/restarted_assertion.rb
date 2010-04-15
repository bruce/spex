module Spex
  class RestartedAssertion < ProcessAssertion
    as :restarted, 'process restart'
    example "Process was restarted", "assert 'postfix', :restarted => true"
    example "Process was not restarted", "assert 'postfix', :restarted => false"

    def before
      @before_pid = current_pid
      assert @before_pid, "Process '#{target}' is not running"
    end

    def after
      after_pid = current_pid
      assert after_pid, "Process '#{target}' is not running"
      if active?
        assert_not_equal @before_pid, after_pid, "Process '#{target}' pid was not changed (still #{@before_pid})"
      else
        assert_equal @before_pid, after_pid, "Process '#{target}' pid was changed (was #{@before_pid}, now #{after_pid})"
      end
    end
  end
end
