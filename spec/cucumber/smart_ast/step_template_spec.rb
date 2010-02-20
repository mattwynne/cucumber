require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe StepTemplate do
      before do
        @step_template = StepTemplate.new("Given", "<num> Cucumbers in my <object>", 1)
      end
      
      it "should interpolate variable arguments" do
        example_step = @step_template.create_example_step(%w{num object}, %w{5 belly}, 0)
        example_step.instance_variable_get('@name').should == "5 Cucumbers in my belly"
      end
    end
  end
end
