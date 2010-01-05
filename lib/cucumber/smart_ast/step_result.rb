module Cucumber
  module SmartAst
    class StepResult
      attr_reader :status, :step

      def initialize(status, step, unit, exception=nil)
        @status, @step, @unit, @exception = status, step, unit, exception
      end
      
      def accept(visitor)
        if @unit.example?
          visitor.example_step_result(self)
        else
          visitor.scenario_step_result(self)
        end
      end

      def to_s
        msg = "#{status.to_s.capitalize}: #{step} on line #{step.line}"
        msg += " #{@exception.to_s}" if @exception
        msg
      end

      def failure?
        [:undefined, :pending, :failed].include?(@status)
      end
    end
  end
end
