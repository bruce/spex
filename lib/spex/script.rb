module Spex
  class Script
    include Enumerable

    attr_accessor :command

    def self.evaluate_file(path)
      evaluate(File.read(path), path, 1)
    end

    def self.evaluate(*args, &block)
      script = new
      builder = Builder.new(script, &block)
      unless block_given?
        builder.instance_eval(*args)
      end
      script
    end

    def <<(scenario)
      scenarios << scenario
    end

    def scenarios
      @scenarios ||= []
    end

    def each(&block)
      scenarios.each(&block)
    end

    class Builder

      def initialize(script, &block)
        @script = script
        instance_eval(&block) if block_given?
      end
      
      def scenario(name, &block)
        scenario = ::Spex::Scenario.new(name, &block)
        @script << scenario
      end

    end

  end
end   
