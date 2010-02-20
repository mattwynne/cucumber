# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe Table do
      before do
        @table = Table.new([
          %w{ one  four  seven  },
          %w{ 4444 55555 666666 }
        ], 1)
      end
      
      it "should have the raw table" do
        @table.raw[0].should == %w{one four seven}
      end

      it "should have rows" do
        @table.rows[0].should == %w{4444 55555 666666}
      end
      
      it "should have columns" do
        @table.columns[1].should == %w{four 55555}
      end

      it "should have headers" do
        @table.headers.should == %w{one four seven}
      end
      
      it "should be convertible to an array of hashes" do
        @table.hashes.should == [
          {'one' => '4444', 'four' => '55555', 'seven' => '666666'}
        ]
      end
      
      it "should accept symbols as keys for the hashes" do
        @table.hashes.first[:one].should == '4444'
      end
      
      describe "#transpose" do
        before(:each) do
          @table = Table.new([
            %w{one 1111},
            %w{two 22222}
          ], 1)
        end

        it "should be convertible in to an array where each row is a hash" do 
          @table.transpose.hashes[0].should == {'one' => '1111', 'two' => '22222'}
        end
      end
      
      describe "#rows_hash" do          
        it "should return a hash of the rows" do
          table = Table.new([
            %w{one 1111},
            %w{two 22222}
          ], 1)
          table.rows_hash.should == {'one' => '1111', 'two' => '22222'}
        end

        it "should fail if the table doesn't have two columns" do
          faulty_table = Table.new([
            %w{one 1111 abc},
            %w{two 22222 def}
          ], 1)
          lambda {
            faulty_table.rows_hash
          }.should raise_error('The table must have exactly 2 columns')
        end
      end
    end
  end
end