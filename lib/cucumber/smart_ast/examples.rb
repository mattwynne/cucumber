require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples
      include Tags
      include Description
      
      attr_reader :keyword, :description, :line
      
      def initialize(keyword, description, line, tags, scenario_outline)
        @keyword, @description, @line, @tags, @scenario_outline = keyword, description, line, tags, scenario_outline
      end
      
      def feature
        @scenario_outline.feature
      end

      def table!(rows, line)
        table = Table.new(rows, line)
        table.hashes.each_with_index do |hash, row_index|
          yield Example.new(hash, table.line + row_index, self)
        end
      end

      def steps(hash)
        @scenario_outline.steps(hash)
      end
    end
  end
end
