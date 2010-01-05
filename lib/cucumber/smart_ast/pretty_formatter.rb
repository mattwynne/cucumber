require 'cucumber/smart_ast/pretty_printer'
module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @printer = PrettyPrinter.new(io)
      end
      
      def before_unit(unit)
        on_new_feature(unit) do |feature|
          @printer.feature(feature)
        end
        
        if unit.from_outline?
          on_new_scenario_outline(unit) do |scenario_outline|
            @printer.scenario_outline(scenario_outline)
          end
          
          on_new_examples_table(unit) do |examples_table|
            @printer.examples_table(examples_table)
          end
        else
          @printer.scenario(unit)
        end
      end
      
      def after_step(step_result)
        step_result.accept(@printer)
      end
      
      def after_unit(unit_result)
        @printer.after_example(unit_result) if unit_result.unit.from_outline?
      end
      
      private

      def on_new_feature(unit)
        if @feature != unit.feature
          @feature = unit.feature
          yield @feature
        end
      end
      
      def on_new_scenario_outline(unit)
        if @scenario_outline != unit.scenario_outline
          @scenario_outline = unit.scenario_outline
          yield @scenario_outline
        end
      end
      
      def on_new_examples_table(unit)
        if @examples_table != unit.examples
          @examples_table = unit.examples
          yield @examples_table
        end
      end

    end
  end
end