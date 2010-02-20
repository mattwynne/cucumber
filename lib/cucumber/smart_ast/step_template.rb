require 'gherkin/format/argument'
require 'cucumber/smart_ast/example_step'

module Cucumber
  module SmartAst
    # Children of ScenarioOutline.
    class StepTemplate

      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def table!(rows, line)
        @argument = Table.new(rows, line)
      end

      def py_string!(content, line)
        @argument = PyString.new(content, line)
      end

      def create_example_step(keys, values, line)
        columns = []

        name = @name.dup
        keys.each_with_index do |key, n|
          # TODO: Use zip?
          if replace(key, values[n], name)
            columns << n
          end
        end

        ExampleStep.new(self, @keyword, name, line, columns, @argument)
      end

      def report_to(gherkin_listener)
        gherkin_listener.step(@keyword, @name, @line, :skipped, arguments)
        @argument.report_to(gherkin_listener) if @argument
      end

      def location(line)
        nil
      end

    private

      def replace(key, value, name)
        if name =~ /<#{key}>/
          name.gsub!(/<#{key}>/, value)
          true
        end
      end

      PARAM_PATTERN = /<[^>]*>/m

      def arguments
        args = []
        byte_offset = -1
        @name.scan(PARAM_PATTERN) do |val|
          byte_offset = @name.index(val, byte_offset+1)
          args << Gherkin::Format::Argument.new(byte_offset, val)
        end
        args
      end
    end
  end
end
