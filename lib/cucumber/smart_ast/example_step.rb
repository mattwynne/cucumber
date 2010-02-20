module Cucumber
  module SmartAst
    class ExampleStep
      def initialize(step_template, keyword, name, line, columns, multiline_argument)
        @step_template, @keyword, @name, @line, @columns, @multiline_argument = step_template, keyword, name, line, columns, multiline_argument
      end

      def execute(unit_result, step_mother, skip)
        step_result = StepResult.new(unit_result, self)
        step_result.execute(step_mother, @name, @multiline_argument, skip)
        step_result
      end

      def file_colon_line
        @step_template.location(@line)
      end

      def report_result(gherkin_listener, status, arguments, location, exception)
        # NO-OP
      end
    end
  end
end