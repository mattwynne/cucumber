require 'gherkin/tools/pretty_listener'

module Cucumber
  module SmartAst
    # TODO: Rename to StructureFormatter - or maybe StructureReporter,
    # this class can delegate to several formatters, including Pretty, HTML and PDF.
    class PrettyFormatter
      def initialize(_,io,__,monochrome=false)
        @listener = Gherkin::Tools::PrettyListener.new(io, monochrome)
      end

      def before_unit(unit)
        unit.accept(self)
      end

      def after_step(step_result)
        step_result.accept(self)
      end
      
      def after_unit(unit_result)
        unit_result.accept(self)
      end

      # AST Visitor API. TODO: Split this class in 2:
      # * VisitorListener (for before_unit, after_step, after_unit)
      # * ReportVisitor (for the rest)
      # ** That takes a GherkinListener as ctor arg 
      
      def visit_feature(feature)
        if(feature != @last_feature)
          @last_feature = feature
          feature.report_to(@listener)
        end
      end

      def visit_scenario(scenario)
        scenario.report_to(@listener)
      end

      def visit_scenario_outline(scenario_outline)
        if(scenario_outline != @last_scenario_outline)
          @last_scenario_outline = scenario_outline
          scenario_outline.report_to(@listener)
        end
      end

      def visit_examples(examples)
        if(examples != @last_examples)
          @last_examples = examples
          examples.report_to(@listener)
        end
      end

      def visit_example(example)
        example.report_to(@listener)
      end

      def visit_unit_result(unit_result)
        unit_result.report_to(@listener)
      end

      def visit_step_result(step_result)
        step_result.report_to(@listener)
      end
    end
  end
end