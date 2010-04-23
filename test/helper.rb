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

  def check_passes(&block)
    @check.prepare
    @check.before
    yield if block_given?
    @check.after
  end

  def check_fails_before
    assert_raises Test::Unit::AssertionFailedError do
      @check.prepare
      @check.before
    end
  end

  def check_fails(&block)
    assert_raises Test::Unit::AssertionFailedError do
      check_passes(&block)
    end
  end

  def start_process!(pid = '100')
    flexmock(@check).flexmock_teardown
    flexmock(@check).should_receive(:current_pid).and_return(pid)
  end

  def stop_process!
    flexmock(@check).flexmock_teardown
    flexmock(@check).should_receive(:current_pid).and_return(nil)    
  end
  
end
