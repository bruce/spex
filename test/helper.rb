require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'stringio'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spex'
require 'fakefs/safe'
require 'flexmock/test_unit'

class Test::Unit::TestCase

  private

  def script(&block)
    @script = Spex::Script.evaluate(&block)
  end

  def assertion_passes(&block)
    @assertion.prepare
    @assertion.before
    yield if block_given?
    @assertion.after
  end

  def assertion_fails_before
    assert_raises Test::Unit::AssertionFailedError do
      @assertion.prepare
      @assertion.before
    end
  end

  def assertion_fails(&block)
    assert_raises Test::Unit::AssertionFailedError do
      assertion_passes(&block)
    end
  end

  def start_process!(pid = '100')
    flexmock(@assertion).flexmock_teardown
    flexmock(@assertion).should_receive(:current_pid).and_return(pid)
  end

  def stop_process!
    flexmock(@assertion).flexmock_teardown
    flexmock(@assertion).should_receive(:current_pid).and_return(nil)    
  end
  
end
