require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/feature'
require 'cucumber/smart_ast/scenario_outline'

module Cucumber
  module SmartAst
    describe ScenarioOutline do
      describe "#create_examples" do
        before(:each) do
          feature = Feature.new(nil, 'Feature', 'description', 1, [])
          @scenario_outline = ScenarioOutline.new("ScenarioOutline", "Eat things", 1, [], feature)
          [
            ["Given", "I have <start> Cucumbers in my <object>", 1],
            ["When", "I <action> <num> Cucumbers", 2],
            ["Then", "I should have <left> Cucumbers left in my <object>", 3]
          ].each do |row|
            @scenario_outline.create_step(*row)
          end

          @table = [
            %w(start object action num left),
            %w(10 bucket eat 5 5),
            %w(10 belly puke 8 2)
          ]
        end
        
        it "should return an instance of Examples" do
          @scenario_outline.create_examples("Examples", "description", 4, []).should be_kind_of(Examples)
        end
        
        xit "should yield an Example object for each data row in the table" do
          units = []
          examples = @scenario_outline.create_examples("Examples", "", 4, [])
          examples.table!(@table, 99) do |unit|
            units << unit
          end
          
          units.length.should == 2
          
          units.first.steps.map { |step| step.to_s }.should == [
            "Given I have 10 Cucumbers in my bucket",
            "When I eat 5 Cucumbers",
            "Then I should have 5 Cucumbers left in my bucket"
          ]
        
          units.last.steps.map { |step| step.to_s }.should == [
            "Given I have 10 Cucumbers in my belly",
            "When I puke 8 Cucumbers",
            "Then I should have 2 Cucumbers left in my belly"
          ]
        end
        
      end
  
    end
  end
end