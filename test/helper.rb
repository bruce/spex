require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'stringio'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spex'
require 'fakefs/safe'

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

  def assertion_fails(&block)
    assert_raises Test::Unit::AssertionFailedError do
      assertion_passes(&block)
    end
  end
  
end
