require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    class ScenarioStep
      attr_reader :keyword, :name

      def initialize(scenario, keyword, name, line)
        @scenario, @keyword, @name, @line = scenario, keyword, name, line
        @multiline_argument = nil
      end

      def table!(rows, line)
        @multiline_argument = Table.new(rows, line)
      end

      def py_string!(content, line)
        @multiline_argument = PyString.new(content, line)
      end

      def execute(unit_result, step_mother, skip)
        step_result = StepResult.new(unit_result, self)
        step_result.execute(step_mother, @name, @multiline_argument, skip)
        step_result
      end

      def file_colon_line
        @scenario.location(@line)
      end

      def report_result(gherkin_listener, status, arguments, location, exception)
        gherkin_listener.step(@keyword, @name, @line, status, arguments, location)
        @multiline_argument.report_to(gherkin_listener) if @multiline_argument
        gherkin_listener.exception(exception) if exception
      end
    end
  end
end
