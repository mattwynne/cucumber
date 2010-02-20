require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/scenario_step'

module Cucumber
  module SmartAst
    class Scenario
      # TODO: Remove this. We shouldn't need to carry it around
      attr_accessor :language

      attr_reader :steps

      include Comments
      include Tags
      include Description

      def initialize(keyword, description, line, tags, feature)
        @keyword, @description, @line, @tags, @feature = keyword, description, line, tags, feature
        @steps = []
      end

      def create_step(keyword, name, line)
        step = ScenarioStep.new(self, keyword, name, line)
        @steps << step
        step
      end

      # TODO: Rename to matches_tag_expression?(tag_expression)
      def accept_hook?(hook)
        TagExpression.parse(hook.tag_expressions).eval(tags)
      end

      def execute(step_mother, listener)
        step_mother.execute_unit(self, all_steps, listener)
      end

      def accept(visitor)
        @feature.accept(visitor)
        visitor.visit_scenario(self)
      end

      def after(gherkin_listener, unit_result)
        # NO-OP
      end

      def report_to(gherkin_listener)
        gherkin_listener.steps(@steps.map{|step| [step.keyword, step.name]})
        gherkin_listener.scenario(@keyword, @description, @line, location(@line))
      end

      def location(line)
        @feature.location(line)
      end

      private
      
      def all_steps
        @feature.background_steps + @steps
      end
    end
  end
end
