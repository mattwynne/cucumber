require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'cucumber'

module Cucumber
  describe FeatureLoader do
    before do
      require 'cucumber/inputs/file' # Requiring registers plugins
      @file_input = mock('file input service', :read => "Feature: test", :protocols => [:file])
      Inputs::File.stub!(:new).and_return(@file_input)

      require 'cucumber/inputs/http'
      @http_input = mock('http input service', :read => "Feature: test", :protocols => [:http, :https])
      Inputs::HTTP.stub!(:new).and_return(@http_input)

      require 'cucumber/parsers/treetop'
      @gherkin_parser = mock('gherkin parser', :parse => mock('feature', :features= => true, :adverbs => []), :format => :treetop)
      Parsers::Treetop.stub!(:new).and_return(@gherkin_parser)
      
      @textile_parser = mock('textile parser', :parse => mock('feature', :adverbs => [], :features= => true), :format => :textile)
      
      @out = StringIO.new
      @log = Logger.new(@out)

      @feature_loader = FeatureLoader.new
      @feature_loader.log = @log
    end

    def register_parser(parser, &block)
      FeatureLoader.registry[:parsers].push mock('plugin class', :new => parser)
      block.call
      FeatureLoader.registry[:parsers].pop
    end
    
    def register_format_rules(rules, &block)
      FeatureLoader.registry[:format_rules].merge!(rules)
      block.call
      FeatureLoader.registry[:format_rules].clear
    end
        
    it "should split the content name and line numbers from the sources" do
      @file_input.should_receive(:read).with("example.feature")
      @feature_loader.load_feature("example.feature:10:20")
    end
    
    it "should load a feature from a file" do
      @file_input.should_receive(:read).with("example.feature").once
      @feature_loader.load_feature("example.feature")
    end

    it "should load a feature from a file with spaces in the name" do
      @file_input.should_receive(:read).with("features/spaces are nasty.feature").once
      @feature_loader.load_feature("features/spaces are nasty.feature")
    end
    
    it "should load features from multiple input sources" do
      @http_input.should_receive(:read).with("http://test.domain/http.feature").once
      @file_input.should_receive(:read).with("example.feature").once
      @feature_loader.load_features(["example.feature", "http://test.domain/http.feature"])
    end
    
    it "should say it supports the protocols provided by the registered input services" do
      @feature_loader.protocols.should include(:http, :https, :file)
    end
    
    it "should raise if it has no input service for the protocol" do
      lambda {
       @feature_loader.load_feature("accidentally://the.whole/thing.feature") 
      }.should raise_error(InputServiceNotFound, /.*'accidentally'.*Services available:.*/)
    end

    it "should parse a feature written in Gherkin" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("example.feature")
    end
    
    it "should default to the Gherkin format" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("jbehave.scenario")
    end
    
    it "should assume the Gherkin format if there is no extension" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("example")
    end
    
    it "should determine the feature format by the file extension" do
      @textile_parser.should_receive(:parse).with(anything(), "example.textile", anything(), anything()).once
      @gherkin_parser.should_receive(:parse).with(anything(), "example.feature", anything(), anything()).once
      
      register_parser(@textile_parser) do
        @feature_loader.load_features(["example.feature", "example.textile"])
      end
    end
            
    it "should say it supports the formats parsed by a registered parser" do
      register_parser(@textile_parser) do
        @feature_loader.formats.should include(:textile)
      end
    end
        
    xit "should allow a format rule to override extension-based format determination" do
      @textile_parser.should_receive(:parse).once
      
      register_format_rules({/\.txt$/ => :textile}) do
        register_parser(@textile_parser) do
          @feature_loader.load_feature("example.txt")
        end
      end
    end
        
    xit "should allow format rules to enable parsing features with the same extension in different formats" do
      @textile_parser.should_receive(:parse).once
      @gherkin_parser.should_receive(:parse).once
            
      register_format_rules({/features\/test\/\w+\.feature$/ => :textile}) do
        register_parser(@textile_parser) do
          @feature_loader.load_feature("features/example.feature")
          @feature_loader.load_feature("features/test/example.feature")          
        end
      end
    end
    
    it "should raise AmbiguousFormatRules if two or more format rules match" do
      register_format_rules({/\.foo$/ => :gherkin, /.*/ => :gherkin}) do
        lambda do
          @feature_loader.load_feature("example.foo")
        end.should raise_error(AmbiguousFormatRules)
      end
    end
    
    it "should pull feature names from a feature list" do
      @file_input.should_receive(:list).with("my_feature_list.txt").and_return(["features/foo.feature", "features/bar.feature"])
      @feature_loader.load_features(["@my_feature_list.txt"])
    end
  end
end
