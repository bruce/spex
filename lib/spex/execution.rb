module Spex
  class Execution
    include Enumerable
    
    attr_reader :command
    
    def initialize(command, &block)
      @command = command
      Builder.new(self, &block)
    end

    def checks
      @checks ||= []
    end

    def <<(check)
      checks << check
    end

    def each(&block)
      checks.each(&block)
    end

    class Builder
      def initialize(execution, &block)
        @execution = execution
        instance_eval(&block) if block_given?
      end

      def check(target, check_names = {})
        check_names.each do |name, options|
          @execution << Check[name].new(target, options)
        end
      end
    end
  end
end
