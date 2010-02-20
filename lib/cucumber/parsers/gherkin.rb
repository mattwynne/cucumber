require 'cucumber/plugin'
require 'cucumber/filter'
require 'cucumber/smart_ast/feature_builder'
require 'gherkin'
require 'gherkin/i18n'

module Cucumber
  module Parsers
    class Gherkin
      extend Cucumber::Plugin
      register_parser(self)
      register_format_rule(/\.feature$/, :gherkin)
      
      def format
        :gherkin
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains :tag_names or :name_regexps, the result will
      # be filtered.
      def parse(content, path, lines, options)
        # Leave filtering for when the new ast is stable
        # filter = Filter.new(lines, options) 
        
        builder = SmartAst::FeatureBuilder.new(path)
        parser  = ::Gherkin::Parser.new(builder, true, "root")
        lexer   = ::Gherkin::I18nLexer.new(parser)

        lexer.scan(content)
        builder.language = lexer.language
        builder.units
      end
    end
  end
end
