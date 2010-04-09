begin
  require 'thor'
rescue LoadError
  abort "Requires 'thor'"
end

module Stringup
  class CLI < Thor

    desc "info FILE", "Display defined command and scenarios in FILE"
    def info(path)
      script = path_to_script(path)
      puts "FILE\n\n  #{path}\n\n"
      puts "COMMAND\n\n  #{script.command}\n\n"
      puts "SCENARIOS\n\n"
      script.scenarios.sort_by { |k, v| k.to_s }.each do |_, scenario|
        puts "  #{scenario.name}: #{scenario.description}"
        [:before, :after].each do |event|
          puts "    #{event.to_s.upcase}"
          scenario.assertions.each do |assertion|
            puts "      should #{assertion.describe_should_at(event)}"
          end
        end
      end
    end
    
    method_option :scenario, :alias => '-s', :description => "Scenario to run", :default => 'default'
    desc "execute FILE [ARGS_FOR_COMMAND]", "Execute a scenario in FILE"
    def execute(path, *args)
      script = path_to_script(path)
      scenario = script[options[:scenario]]
      unless scenario
        abort "Could not find scenario: #{options[:scenario]}"
      end
      Runner.new(script, scenario, *args).run
    end

    no_tasks do
      def path_to_script(path)
        unless File.exist?(path)
          abort "No stringup file found at #{path}"
        end
        script = Script.evaluate_file(path)
        script.validate!
        script
      end
    end
    
  end
end
