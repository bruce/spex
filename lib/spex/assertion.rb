module Spex
  class Assertion
    extend Enumerable

    class UnknownOptionError < ::ArgumentError; end
    
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

    def self.options
      @options ||= {}
    end

    def self.option(name, description = nil, &block)
      options[name] = Option.new(name, description, &block)
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
      validate!
    end

    def validate!
      options.each do |key, value|
        option = self.class.options[key]
        unless option
          raise UnknownOptionError, key.to_s
        end
      end
    end

    def active?
      @active
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

    def before
      raise NotImplementedError, "Assertion does not describe pre-puppet check"
    end

    def before_should
      raise NotImplementedError, "Assertion does not describe pre-puppet check description"
    end

    # Override and return false if assertions do not need to be made
    # after execution
    def after?
      true
    end

    def after
      raise NotImplementedError, "Assertion does not describe post-puppet check"
    end

    def after_should
      raise NotImplementedError, "Assertion does not describe post-puppet check description"
    end

    def describe_should_at(event)
      send("#{event}_should")
    end

    class Option
      attr_reader :name, :description
      def initialize(name, description = nil, &block)
        @name = name
        @description = description
      end
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'assertions', '**/*.rb')) do |path|
  require path
end

Dir.glob(File.join(ENV['HOME'], '.spex', 'assertions', '**/*.rb')) do |path|
  require path
end
