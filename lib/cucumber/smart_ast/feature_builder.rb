require 'cucumber/smart_ast/feature'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    class FeatureBuilder
      attr_reader :units
      
      def initialize(location)
        @location = location
        @tags = []
        @units = []
      end
      
      def feature(keyword, description, line)
        @current_feature = Feature.new(self, keyword, description, line, grab_tags!)
      end

      def background(keyword, description, line)
        @current_step_container = @current_feature.create_background(keyword, description, line)
      end

      def scenario(keyword, description, line)
        scenario = @current_feature.create_scenario(keyword, description, line, grab_tags!)
        @current_step_container = scenario
        @units << scenario
      end

      def scenario_outline(keyword, description, line)
        scenario_outline = @current_feature.create_scenario_outline(keyword, description, line, grab_tags!)
        @current_scenario_outline = @current_step_container = scenario_outline
      end

      def examples(keyword, description, line)
        @table_consumer = @current_scenario_outline.create_examples(keyword, description, line, grab_tags!)
      end

      def step(keyword, name, line)
        @table_consumer = @current_step_container.create_step(keyword, name, line)
      end

      def table(rows, line)
        @table_consumer.table!(rows, line) do |example|
          @units << example
        end
      end

      def py_string(content, line)
        @table_consumer.py_string!(content, line)
      end

      def tag(tag, line)
        @tags << Tag.new(tag, line)
      end

      def comment(comment, line)
        # TODO: store comment - and implement grab_comments!
      end
      
      def language=(language)
        @current_feature.language = language
      end

      def location(line)
        @location.nil? ? nil : "#{@location}:#{line}"
      end

      private
      
      def create_examples(table, &block)
        @current_scenario_outline.create_examples(
          @cached_examples_node.keyword, 
          @cached_examples_node.description, 
          @cached_examples_node.line, 
          grab_tags!,
          table, 
          &block)
      end
      
      def grab_tags!
        result = @tags.dup
        @tags.clear
        result
      end

    end
  end
end
