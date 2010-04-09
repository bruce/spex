module Stringup
  class Scenario

    attr_reader :name, :description
    def initialize(name, description = name.to_s.capitalize, &block)
      @name = name
      @description = description
      instance_eval(&block)
    end

    def assertions
      @assertions ||= []
    end

    Assertion.each do |name, klass|
      class_eval %{
        def assert_#{name}(*args, &block)
          assertions << Assertion[:#{name}].new(*args, &block)
        end
      }
    end

  end
end
