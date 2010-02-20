require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/examples'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    class ScenarioOutline
      include Comments
      include Tags
      include Description
      
      attr_reader :feature
      
      def initialize(keyword, description, line, tags, feature)
        @keyword, @description, @line, @tags, @feature = keyword, description, line, tags, feature
        @step_templates = []
      end
      
      def create_examples(keyword, description, line, tags)
        Examples.new(keyword, description, line, tags, self)
      end

      def create_example(keys, values, line, row_index, examples)
        example_steps = @step_templates.map{|step_template| step_template.create_example_step(keys, values, line)}
        Example.new(example_steps, row_index, examples)
      end

      def create_step(keyword, name, line)
        step_template = StepTemplate.new(keyword, name, line)
        @step_templates << step_template
        step_template
      end

      def accept(visitor)
        @feature.accept(visitor)
        visitor.visit_scenario_outline(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.scenario(@keyword, @description, @line)
        @step_templates.each do |step_template|
          step_template.report_to(gherkin_listener)
        end
      end
    end
  end
end
