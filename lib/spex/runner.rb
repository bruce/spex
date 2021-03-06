require 'open3'
begin
  require 'colored'
rescue LoadError
  abort "Required the 'colored' library"
end

module Spex
  class Runner
    
    attr_reader :script, :scenario
    def initialize(script, scenario)
      @script = script
      @scenario = scenario
    end
    
    def run
      puts %(Running scenario "#{scenario.name}").magenta.bold
      proceed = true
      scenario.each do |execution|
        puts %(Preparing to execute "#{execution.command}").bold
        execution.checks.each do |check|
          print "Pre-checks for #{check}: "
          check.prepare
          proceed = report { check.before }
          break unless proceed
        end
        if proceed
          print %(Executing "#{execution.command}": )
          start = Time.now
          log = execute(execution)
          elapsed = Time.now - start
          puts 'DONE (%.2fs)' % elapsed
          passed = true
          execution.checks.reverse.each do |check|
            print "Post-checks for #{check}: "
            passed = report { check.after }
            break unless passed
          end
          unless passed
            abort "SCENARIO CHECKS FAILED".red.bold
          end
          output_log(execution, log)
        else
          abort "SCENARIO FAILED (EXECUTION ABORTED)".red.bold
        end
      end
      puts "SCENARIO PASSED".green.bold
    end

    def report(&block)
      yield
      puts 'PASSED'.green
      true
    rescue Test::Unit::AssertionFailedError => e
      puts 'FAILED'.red
      puts e.message.yellow
      puts "At #{find_source(e)}".yellow
      false
    end

    def find_source(e)
      e.backtrace.detect { |line| !line.include?('test/unit') }
    end

    def output_log(execution, log)
      log.each do |stream, content|
        next if content.empty?
        line = "\n#{stream.to_s.upcase} FOR `#{execution.command}`"
        puts line, ('=' * line.size)
        puts content
      end
    end

    def execute(execution)
      log = {:stdout => '', :stderr => ''}
      Open3.popen3(execution.command) do |stdin, stdout, stderr|
        stdin.close
        log[:stdout] << stdout.read
        log[:stderr] << stderr.read
      end
      log
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
          order = parent.execution.checks.reverse
        when :before
          order = parent.execution.checks
        end
        order.each do |check|
          should "pass check #{check.inspect}" do
            check.__send__(event, self)
          end
        end
      end
      klass
    end

  end
end
