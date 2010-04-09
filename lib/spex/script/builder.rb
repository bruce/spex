module Spex
  class Script::Language

    def initialize(script)
      @script = script
    end

    def doing(name, description, &block)
      scenario = Scenario.new(name, description)
      Scenario::Builder.new(scenario, &block)
      @script << scenario
    end
    
  end
end
