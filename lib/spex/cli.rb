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
        opts.banner = 'spex DEFINITION_FILE [OPTIONS]'
        opts.separator "\nOPTIONS:"
        opts.on_tail('--help', '-h', 'Show this message') do
          puts opts
          exit
        end
        opts.on('--describe', '-d', 'Describe DEFINITION_FILE') do
          options.describe = true
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

    def describe(script)
      script.scenarios.each do |scenario|
        puts %(In scenario "#{scenario.name}")
        scenario.executions.each do |execution|
          puts "  When executing `#{execution.command}`"
          execution.assertions.each do |assertion|
            puts "    assert #{assertion}"
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
