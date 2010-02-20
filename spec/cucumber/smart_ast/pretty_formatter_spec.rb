# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/pretty_formatter'
require 'cucumber/smart_ast/feature_builder'
require 'cucumber/smart_ast/features'
require 'cucumber/smart_ast/run'
require 'gherkin'

module Cucumber
  module SmartAst
    module FormatterSpecHelper
      def execute_features(content)
        io = StringIO.new
        formatter = PrettyFormatter.new(nil, io, nil, true)
        
        units = load_units(@feature_content)

        run = Run.new([formatter])
        run.execute(units)

        io.string
      end
      
      private
      
      def load_units(content)
        builder = FeatureBuilder.new(nil)
        parser = ::Gherkin::Parser.new(builder, true, "root")
        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(content)
        builder.units
      end
    end
    
    describe PrettyFormatter do
      include FormatterSpecHelper

      describe "a single feature with a single scenario" do
        before(:each) do
          @feature_content = <<-FEATURES
Feature: Feature Description
  Some preamble

  Scenario: The first one
    Given something

  Scenario: Scenario Description
    Given there is a step
      """
      with
        pystrings
      """
    And there is another step
      | æ | o |
      | a | ø |
    Then we will see steps
          FEATURES
        end
        
        it "should print output identical to the gherkin input" do
          execute_features(@feature_content).should == @feature_content
        end
      end
      
      describe "a single feature with a scenario outline" do
        before(:each) do
          @feature_content = <<-FEATURES
Feature: Feature Description
  Some preamble

  Scenario Outline: Scenario Ouline Description
    Given there is a <foo>
    And <bar> <baz>

    Examples: Examples Description
      | foo    | bar  | baz         |
      | Banana | I    | am hungry   |
      | Beer   | You  | are thirsty |
      | Bed    | They | are tired   |
          FEATURES
        end
        
        it "should print output identical to the gherkin input" do
          io = execute_features(@feature_content)
          io.should == @feature_content
        end
      end

      describe "a single feature with a scenario outline with strings and tables" do
        before(:each) do
          @feature_content = <<-FEATURES
Feature: Feature Description
  Some preamble

  Scenario Outline: Scenario Ouline Description
    Given there is a
      """
      string with <foo>
      """
    And a table with
      | <bar> |
      | <baz> |

    Examples: Examples Description
      | foo    | bar  | baz         |
      | Banana | I    | am hungry   |
      | Beer   | You  | are thirsty |
      | Bed    | They | are tired   |
          FEATURES
        end

        it "should print output identical to the gherkin input" do
          io = execute_features(@feature_content)
          io.should == @feature_content
        end
      end
    end
  end
end