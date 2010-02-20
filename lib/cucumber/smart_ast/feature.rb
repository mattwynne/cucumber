require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/scenario_outline'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Feature
      include Tags
      include Description

      attr_accessor :language, :keyword

      def initialize(feature_builder, keyword, description, line, tags)
        @feature_builder, @keyword, @description, @line = feature_builder, keyword, description, line
        @tags = tags
      end
      
      def create_background(keyword, description, line)
        # TODO: May need a Background class here for proper reporting.
        @background = Scenario.new(keyword, description, line, [], self)
      end
      
      def create_scenario(keyword, description, line, tags)
        Scenario.new(keyword, description, line, tags, self)
      end
      
      def create_scenario_outline(keyword, description, line, tags)
        ScenarioOutline.new(keyword, description, line, tags, self)
      end
      
      def adverbs
        # TODO: is this used??
        @language.adverbs
      end
      
      def background_steps
        @background ? @background.steps : []
      end

      def accept(visitor)
        visitor.visit_feature(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.feature(@keyword, @description, @line)
        @background.report_to(gherkin_listener) if @background
      end

      def location(line)
        @feature_builder.location(line)
      end
    end
  end
end
