require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Example
      include Comments
      include Tags
      include Description
      include Unit
      
      def initialize(hash, line, examples)
        @hash, @line, @examples = hash, line, examples
        #description = hash.values.join(" | ")
      end
      
      def feature
        @examples.feature
      end

      def steps
        @examples.steps(@hash)
      end
    end
  end
end