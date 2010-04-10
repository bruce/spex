module Spex
  class Scenario
    include Enumerable

    attr_reader :name
    def initialize(name, &block)
      @name = name
      Builder.new(self, &block)
    end

    def executions
      @executions ||= []
    end

    def <<(execution)
      executions << execution
    end

    def each(&block)
      executions.each(&block)
    end

    class Builder
      def initialize(scenario, &block)
        @scenario = scenario
        instance_eval(&block) if block_given?
      end

      def executing(command, &block)
        @scenario << Execution.new(command, &block)
      end
    end
  end
end
