# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/builder_spec_helper')

module Cucumber
  module SmartAst
    describe FeatureBuilder do
      include SpecHelper
      
      before(:each) do
        @units = load_units(feature_content)
      end
    
      describe "for a Feature with a single Scenario" do
        def feature_content
          <<-FEATURE
            @foo
            Feature: Getting things done
              A
              B
              C
    
              @bar
              Scenario: Do some stuff
                Given I am ready to do stuff
                When I do some stuff
                Then I should be in the pub celebrating
          FEATURE
        end
        
        it { @units.length.should == 1 }
        
        describe "the scenario" do
          before(:each) { @scenario = @units.first }
          
          xit { @scenario.description.should == "Do some stuff" }
          
          xit "should get its own tags" do
            @scenario.tags.include?(Tag.new("bar")).should be_true
          end
          
          xit "should inherit tags from the parent" do
            @scenario.tags.include?(Tag.new("foo")).should be_true
          end
          
          xit "should create each step with the correct name" do
            [
              "I am ready to do stuff",
              "I do some stuff",
              "I should be in the pub celebrating"
            ].each_with_index do |expected_name, index|
              @scenario.steps[index].name.should == expected_name
            end
          end
          
          xit "should create each step with the correct keyword" do
            ["Given", "When", "Then"].each_with_index do |expected_keyword, index|
              @scenario.steps[index].keyword.should == expected_keyword
            end
          end
        end
      end
      
      describe "a Scenario with multiline arguments" do
        def feature_content
          <<-FEATURE
            Feature: Foo
              Scenario: Bar
                Given there is a step
                  """
                  with
                    pystrings
                  """
                And there is another step
                  | æ | o |
                  | a | ø |
          FEATURE
        end
        
        it "should create a Unit for the scenario" do
          @units.length.should == 1
        end
        
        xit "should append the multiline args correctly to the steps" do
          @units.first.steps[0].argument.should be_instance_of(PyString)
          @units.first.steps[1].argument.should be_instance_of(Table)
        end
      end
      
      describe "a Feature with a Scenario Outline" do
        def feature_content
          <<-FEATURE
          Feature: Feature Description
            Some preamble
            
            Background:
              Given this has happened

            Scenario Outline: Scenario Ouline Description
              Given there is a <foo>
                """
                with a
                multiline <fruit>
                """
              And <bar> <baz>
                |with|<animal>|

              Examples: Examples Description
                | foo        | bar | baz        | fruit  | animal |
                | restaurant | I   | am hungry  | apple  | cow    |
                | pub        | I   | am thirsty | orange | horse  |
          FEATURE
        end
        
        it "should create a Unit for each Example" do
          @units.length.should == 2
        end
        
        xit "should put the background steps onto each Example" do
          @units.first.steps.length.should == 3
          @units.first.steps[0].name.should == "this has happened"
        end
        
        xit "should generate steps for each Example" do
          @units.first.steps[1].name.should == "there is a restaurant"
          @units.first.steps[2].name.should == "I am hungry"
        end

        xit "should replace values in pystring" do
          @units.first.steps[1].argument.to_s.should == "with a\nmultiline apple"
        end
      end
    end
  end
end