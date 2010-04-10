module Spex
  class Execution
    include Enumerable
    
    attr_reader :command
    
    def initialize(command, &block)
      @command = command
      Builder.new(self, &block)
    end

    def assertions
      @assertions ||= []
    end

    def <<(assertion)
      assertions << assertion
    end

    def each(&block)
      assertions.each(&block)
    end

    class Builder
      def initialize(execution, &block)
        @execution = execution
        instance_eval(&block) if block_given?
      end

      def assert(target, assertion_names = {})
        assertion_names.each do |name, options|
          @execution << Assertion[name].new(target, options)
        end
      end
    end
  end
end
