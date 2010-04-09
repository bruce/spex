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

module Stringup
  class Runner
    
    attr_reader :script, :scenario
    def initialize(script, scenario, *args)
      @script = script
      @scenario = scenario
      @args = args
      @log = ''
    end
    
    def run
      Test::Unit.run = false
      suite = Test::Unit::TestSuite.new("#{scenario.description} (`#{command}`)")
      suite << test(:before).suite
      suite << test(:after).suite
      Test::Unit::UI::Console::TestRunner.run(suite)
      output_log
    end

    def output_log
      if @log.empty?
        puts "NO OUTPUT FROM `#{command}`"
      else
        line = "\nOUTPUT FROM `#{command}`"
        puts line, ('=' * line.size)
        puts @log
      end
    end

    def run_command
      Open3.popen3(command) do |stdin, stdout, stderr|
        stdin.close
        @log << stdout.read
        @log << stderr.read
      end
      true
    end

    def test(event)
      klass = Class.new(Test::Unit::TestCase) do
        class << self; attr_accessor :stringup, :name, :event; end
      end
      klass.name = "Stringup::Test::Order#{event == :after ? 1 : 0}::#{event.to_s.capitalize}Puppet"
      klass.stringup = self
      klass.event = event
      klass.context "#{event} `#{command}`" do
        if parent.event == :after
          setup do
            @ran_puppet ||= self.class.stringup.run_command
          end
        end
        parent.stringup.scenario.assertions.each do |assertion|
          if assertion.send("#{event}?")
            should assertion.describe_should_at(event) do
              assertion.__send__(event, self)
            end
          end
        end
      end
      klass
    end

    private

    def command
      @command ||= @script.command % @args
    rescue ArgumentError
      abort "You provided the wrong number of arguments for command: #{@script.command}"
    end

  end
end
