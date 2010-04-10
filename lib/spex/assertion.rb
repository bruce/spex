module Spex
  class Assertion
    extend Enumerable
    
    def self.each(&block)
      registry.each(&block)
    end
    
    def self.[](name)
      registry[name]
    end
    
    def self.registry
      @registry ||= {}
    end
    
    def self.assertion(name)
      Assertion.registry[name.to_sym] = self
    end

    attr_reader :target, :options
    def initialize(target, options = {})
      @target = target
      if options.is_a?(Hash)
        @options = options
        @active = true
      else
        @options = {}
        @active = options
      end
    end

    def active?
      @active
    end

    def describe_should_at(event)
      case event
      when :before
        raise NotImplementedError, "Assertion does not describe pre-puppet check"
      when :after
        raise NotImplementedError, "Assertion does not describe post-puppet check"
      else
        raise ArgumentError, "Unknown event #{event.inspect}"
      end
    end

    # Override to support an operation occuring before execution (even
    # if assertions aren't added via +before+ because +before?+
    # returns false).
    def mark!
    end

    # Override and return false if assertions do not need to be made
    # before execution
    def before?
      true
    end

    # Override and return false if assertions do not need to be made
    # after execution
    def after?
      true
    end

  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'assertions', '**/*.rb')) do |path|
  require path
end

Dir.glob(File.join(ENV['HOME'], '.spex', 'assertions', '**/*.rb')) do |path|
  require path
end
