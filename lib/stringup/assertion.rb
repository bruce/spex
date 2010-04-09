module Stringup
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

  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'assertions', '**/*.rb')) do |path|
  require path
end

Dir.glob(File.join(ENV['HOME'], '.stringup', 'assertions', '**/*.rb')) do |path|
  require path
end
