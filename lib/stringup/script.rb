module Stringup
  class Script

    attr_accessor :command

    def self.evaluate_file(path)
      evaluate(File.read(path), path)
    end

    def self.evaluate(text, path)
      script = new
      Builder.new(script).instance_eval(text, path, 1)
      script
    end

    def <<(scenario)
      scenarios[scenario.name.to_sym] = scenario
    end

    def scenarios
      @scenarios ||= {}
    end

    def [](name)
      scenarios[name.to_sym]
    end

    def validate!
      unless @command
        abort "ERROR: The command was not set.\n\nExample:\n\n  command 'cat %s'"
      end
    end

    class Builder

      def initialize(script, &block)
        @script = script
        instance_eval(&block) if block_given?
      end
      
      def scenario(name, description = name.to_s, &block)
        scenario = ::Stringup::Scenario.new(name, description, &block)
        @script << scenario
      end
      def command(line)
        @script.command = line
      end

    end

  end
end   
