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
    
    context "a scenario and execution definition with an check" do
      setup do
        script do
          scenario("name") do
            executing('foo') do
              check '/tmp/foo', :created => true
            end
          end
        end
      end
      
      should "create an check instance" do
        execution = @script.scenarios.first.executions.first
        assert_equal 1, execution.checks.size
        check = execution.checks.first
        assert_kind_of Spex::Check, check
        assert_equal '/tmp/foo', check.target
        assert check.active?
        assert_equal({}, check.options)
      end
    end

  end
end
