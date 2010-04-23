require 'test/unit/assertions'

module Spex
  class Check
    include Test::Unit::Assertions
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

    def self.as(name, description)
      self.name = name
      self.description = description
      Check.registry[name.to_sym] = self
    end

    def self.example(description, text)
      examples << [description, text]
    end

    def self.examples
      @examples ||= []
    end

    def self.options
      @options ||= {}
    end

    def self.option(name, description = nil, &block)
      options[name] = Option.new(name, description, &block)
    end

    class << self; attr_accessor :name, :description; end

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

    def prepare
    end

    def before
    end

    def after
    end

    def to_s
      "#{self.class.description} of #{target}"
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

Dir.glob(File.join(File.dirname(__FILE__), 'checks', '**/*.rb')) do |path|
  require path
end

Dir.glob(File.join(ENV['HOME'], '.spex', 'checks', '**/*.rb')) do |path|
  require path
end
