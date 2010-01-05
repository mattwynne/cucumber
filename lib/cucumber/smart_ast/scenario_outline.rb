require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/examples'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    class ScenarioOutline
      include Tags
      include Description
      
      attr_reader :feature
      
      def initialize(keyword, description, line, tags, feature)
        @keyword, @description, @line, @tags, @feature = keyword, description, line, tags, feature
        @step_templates = []
      end
      
      def create_examples(keyword, description, line, tags)
        examples = Examples.new(keyword, description, line, tags, self)
      end
      
      def create_step(keyword, name, line)
        step_template = StepTemplate.new(keyword, name, line, self)
        @step_templates << step_template
        step_template
      end
      
      def steps(hash)
        @feature.background_steps + @step_templates.map { |step_template| step_template.interpolate(hash) }
      end
    end
  end
end
