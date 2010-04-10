require 'open3'

begin
  require 'shoulda'
rescue LoadError
  abort "Requires 'shoulda'"
end

begin
  require 'test/unit'
rescue LoadError
  abort "Requires 'test/unit'.  On Ruby 1.9 you may need to install the 'test-unit' gem."
end

require 'test/unit/ui/console/testrunner'

module Spex
  class Runner
    
    attr_reader :script, :scenario
    def initialize(script, scenario, *args)
      @script = script
      @scenario = scenario
      @args = args
      @log = {}
    end
    
    def run
      Test::Unit.run = false
      suite = Test::Unit::TestSuite.new(scenario.name)
      scenario.executions.each_with_index do |execution, index|
        execution_suite = Test::Unit::TestSuite.new("`#{execution.command}` (##{index + 1})")
        suite << execution_suite
        execution_suite << test(execution, :before).suite
        execution_suite << test(execution, :after).suite
        execution.each { |assertion| assertion.mark! }
      end
      Test::Unit::UI::Console::TestRunner.run(suite)
      scenario.each do |execution|
        output_log(execution)
      end
    end

    def output_log(execution)
      if @log[execution].values.all? { |v| v.empty? }
        puts "NO OUTPUT FROM `#{execution.command}`"
      else
        line = "\nOUTPUT FROM `#{execution.command}`"
        puts line, ('=' * line.size)
        puts @log[execution].values.join("\n")
      end
    end

    def execute(execution)
      @log[execution] = {:stdout => '', :stderr => ''}
      Open3.popen3(execution.command) do |stdin, stdout, stderr|
        stdin.close
        @log[execution][:stdout] << stdout.read
        @log[execution][:stderr] << stderr.read
      end
      true
    end

    def test(execution, event)
      klass = Class.new(Test::Unit::TestCase) do
        class << self; attr_accessor :execution, :spex_runner, :name, :event; end
      end
      klass.name = "Spex::Test::Order#{event == :after ? 1 : 0}::#{event.to_s.capitalize}Execution"
      klass.spex_runner = self
      klass.execution = execution
      klass.event = event
      klass.context "#{event} executing `#{execution.command}`" do
        case parent.event
        when :after
          setup do
            @executed ||= self.class.spex_runner.execute(self.class.execution)
          end
          order = parent.execution.assertions.reverse
        when :before
          order = parent.execution.assertions
        end
        order.each do |assertion|
          if assertion.send("#{event}?")
            should assertion.describe_should_at(event) do
              assertion.__send__(event, self)
            end
          end
        end
      end
      klass
    end

  end
end
