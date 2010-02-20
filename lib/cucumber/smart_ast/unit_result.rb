module Cucumber
  module SmartAst
    class UnitResult
      def initialize(unit)
        @unit = unit
        @statuses = []
      end

      def status!(status, exception)
        @statuses << status
        @exception = exception
      end

      def accept(visitor)
        visitor.visit_unit_result(self)
      end

      def report_to(gherkin_listener)
        @unit.after(gherkin_listener, self)
      end

      def report_as_row(gherkin_listener, rows, line, row, row_index)
        raise "row has different dimensions from statuses: #{row.inspect}, #{@statuses.inspect}" if row.length != @statuses.length
        gherkin_listener.table(rows, line, [row], row_index, @statuses, @exception)
      end

      def accept_hook?(hook)
        @unit.accept_hook?(hook)
      end
    end
  end
end
