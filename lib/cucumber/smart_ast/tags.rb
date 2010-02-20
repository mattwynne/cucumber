require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    # TODO: Remove me!! Cruft.
    module Tags      
      def tags
        @tags ||= []
      end
    end
  end
end
