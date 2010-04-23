require 'optparse'
require 'ostruct'

module Spex
  class CLI

    def initialize(args = [])
      @args = args
    end

    def options
      @options ||= OpenStruct.new
    end
    
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "spex [OPTIONS] DEFINITION_FILE"
        opts.separator "\nOPTIONS:"
        opts.on_tail('--help', '-h', 'Show this message') do
          puts opts
          exit
        end
        opts.on('--describe', '-d', 'Describe DEFINITION_FILE') do
          options.describe = true
        end
        opts.on('--checks', '-c', "List supported checks") do
          display_checks
          exit
        end
      end
    end

    def run
      parser.parse!(@args)
      filename = @args.shift
      if !filename
        refuse "No definition file given"
      elsif !File.exist?(filename)
        refuse "Definition file not found: #{filename}"
      else
        accept(filename)
      end
    end

    private

    def accept(filename)
      script = evaluate(filename)
      if options.describe
        describe(script)
      else
        execute(script)
      end
    end

    def display_checks
      Check.registry.each_value do |klass|
        line = "Check: :#{klass.name} (#{klass.description})"
        puts line
        if klass.options.any? || klass.examples.any?
          puts('=' * line.size)
        end
        if klass.options.any?
          puts "\nOptions\n-------\n\n"
          klass.options.each do |key, value|
            puts "*  :#{key}, #{value.description}"
          end
        end
        if klass.examples.any?
          puts "\nExamples\n--------\n\n"
          klass.examples.each do |description, example|
            puts "#{description}:"
            puts "\n    #{example}\n\n"
          end
        end
        puts
      end
    end

    def describe(script)
      script.scenarios.each do |scenario|
        puts %(In scenario "#{scenario.name}")
        scenario.executions.each do |execution|
          puts "  When executing `#{execution.command}`"
          execution.checks.each do |check|
            puts "    assert #{check}"
          end
        end
      end
    end

    def execute(script)
      script.each do |scenario|
        Runner.new(script, scenario).run
      end
    end
    
    def refuse(error)
      abort "ERROR: #{error}\n\n#{parser}"
    end

    def evaluate(filename)
      Script.evaluate_file(filename)
    end
    
  end
end
