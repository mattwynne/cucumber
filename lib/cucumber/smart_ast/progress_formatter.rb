module Cucumber
  module SmartAst
    # TODO: Rename to StructureFormatter - or maybe StructureReporter,
    # this class can delegate to several formatters, including Pretty, HTML and PDF.
    class ProgressFormatter
      def initialize(_,io,__)
        @io = io
      end

      def before_unit(unit)
      end

      def after_step(step_result)
        step_result.accept(self)
      end
      
      def after_unit(unit_result)
      end

      def visit_step_result(step_result)
        step_result.report_to(self)
      end

      def step(keyword, name, line)
        @io.write('.')
      end
    end
  end
end