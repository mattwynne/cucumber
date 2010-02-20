require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/scenario_outline'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    describe Example do
      it "should have steps with replaced tokens" do
        so = ScenarioOutline.new(keyword="Scenario Outline", name="whatever", line=10, tags=nil, feature=nil)
        step_template = so.create_step(keyword="Given", name="I have <n> cukes", 11)
        
        examples = so.create_examples(keyword="Examples", description="", line=12, tags=nil)
        
        example_array = []
        examples.table!([%w{n}, %w{5}, %w{7}, %w{13}], line=13) do |example|
          example_array << example
        end
        
        example_array.length.should == 3
        example = example_array[0]
        # TODO: assert soemthing!!
      end
    end
  end
end
