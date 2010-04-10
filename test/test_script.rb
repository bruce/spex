require 'helper'

class TestScript < Test::Unit::TestCase
  context "evaluating" do
    context "an empty scenario definition" do
      setup do
        script { scenario("name") { } }
      end
      
      should "create an empty scenario" do
        assert_equal 1, @script.scenarios.size
        assert_equal "name", @script.scenarios.first.name
      end
    end
    context "a scenario definition with an executing definition" do
      setup do
        script { scenario("name") { executing('foo') { } } }
      end
      
      should "create an scenario" do
        assert_equal 1, @script.scenarios.size
        assert_equal "name", @script.scenarios.first.name
      end

      should "create an execution instance" do
        assert_equal 1, @script.scenarios.first.executions.size
        assert_equal 'foo', @script.scenarios.first.executions.first.command
      end
    end
    
    context "a scenario and execution definition with an assertion" do
      setup do
        script do
          scenario("name") do
            executing('foo') do
              assert '/tmp/foo', :created => true
            end
          end
        end
      end
      
      should "create an assertion instance" do
        execution = @script.scenarios.first.executions.first
        assert_equal 1, execution.assertions.size
        assertion = execution.assertions.first
        assert_kind_of Spex::Assertion, assertion
        assert_equal '/tmp/foo', assertion.target
        assert assertion.active?
        assert_equal({}, assertion.options)
      end
    end

  end
end
