require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/scenario_step'

module Cucumber
  module SmartAst
    describe ScenarioStep do
      it "should delegate execution to StepMother" do
        step = ScenarioStep.new(nil, "Given ", "I have 10 cukes in my belly", 10)
        
        step_mother = mock('step_mother')
        unit_result = mock('unit_result')
        
        step_mother.should_receive(:invoke).with("I have 10 cukes in my belly", nil)
        unit_result.should_receive(:status!).with(:passed, nil)

        step.execute(unit_result, step_mother)
      end
    end
  end
end