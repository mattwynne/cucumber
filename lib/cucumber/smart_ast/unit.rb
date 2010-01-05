require 'cucumber/ast/tags'
require 'cucumber/smart_ast/step_result'
require 'cucumber/smart_ast/unit_result'
require 'cucumber/smart_ast/listeners_broadcaster'

module Cucumber
  module SmartAst
    module Unit
      class StepsRunner
        def initialize(run, unit, steps)
          @run, @unit, @steps = run, unit, steps
          @results = []
        end
        
        def execute
          @steps.each do |step|
            @run.before_step(step)
            result = execute_step(step)
            @results << result
            @run.after_step(result)
          end

          UnitResult.new(@unit, @results)
        end
        
        private
        
        def failed?
          @results.any?{ |r| r.failure? }
        end
        
        def execute_step(step)
          return StepResult.new(:skipped, step, @unit) if failed?
          @run.execute_step(step, @unit)
        end
      end
      
      def accept_hook?(hook)
        tags = @tags.map { |tag| "@#{tag.name}" }
        TagExpression.parse(hook.tag_expressions).eval(tags)
      end
      
      def fail!(exception)
        raise exception
      end
      
      def execute(run)
        StepsRunner.new(run, self, all_steps).execute
      end
      
      def example?
        self.is_a?(Example)
      end
      
      private
      
      def all_steps
        feature.background_steps + @steps
      end
      
    end
  end
end
