require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    # An Example instance is created for each non-header row in an Examples
    # table
    class Example
      # TODO: Remove this. We shouldn't need to carry it around
      attr_accessor :language
      
      include Comments
      include Tags
      include Description

      def initialize(example_steps, row_index, examples)
        @example_steps, @row_index, @examples = example_steps, row_index, examples
      end

      # TODO: Rename to matches_tag_expression?(tag_expression)
      def accept_hook?(hook)
        TagExpression.parse(hook.tag_expressions).eval(tags)
      end

      def execute(step_mother, listener)
        step_mother.execute_unit(self, @example_steps, listener)
      end

      def accept(visitor)
        @examples.accept(visitor)
        visitor.visit_example(self)
      end

      def report_to(gherkin_listener)
        # NO-OP
      end
      
      def feature
        @examples.feature
      end

      def after(gherkin_listener, unit_result)
        @examples.report_result(gherkin_listener, unit_result, @row_index)
      end
    end
  end
end