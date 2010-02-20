require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'gherkin'
require 'gherkin/i18n'
require 'cucumber/smart_ast/feature_builder'

module Cucumber
  module SmartAst
    module SpecHelper
      def load_units(content = feature_content)
        builder = FeatureBuilder.new
        parser = ::Gherkin::Parser.new(builder, true, "root")
        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(content)
        builder.units
      end
    end
  end
end