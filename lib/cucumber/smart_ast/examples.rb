require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, scenario_outline)
        @keyword, @description, @line, @tags, @scenario_outline = keyword, description, line, tags, scenario_outline
      end
      
      def feature
        @scenario_outline.feature
      end

      def table!(rows, line)
        @rows = rows
        @table_line = line
        @rows[1..-1].each_with_index do |row, row_index|
          yield @scenario_outline.create_example(@rows[0], row, line+=1, row_index+1, self)
        end
      end

      def accept(visitor)
        @scenario_outline.accept(visitor)
        visitor.visit_examples(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.examples(@keyword, @description, @line)
        gherkin_listener.table(@rows, @table_line, [@rows[0]], 0, Array.new(@rows[0].length) {:outline_param})
      end

      def execute(row, step_mother, listener)
        @scenario_outline.execute(@rows[0], row, step_mother, listener)
      end

      def report_result(gherkin_listener, unit_result, row_index)
        row = @rows[row_index]
        unit_result.report_as_row(gherkin_listener, @rows, @table_line+row_index, row, row_index)
      end
    end
  end
end
