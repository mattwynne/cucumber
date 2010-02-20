module Cucumber
  module SmartAst
    class PyString
      def self.default_arg_name
        "string"
      end

      def initialize(content, line)
        @content, @line = content, line
      end
      
      def accept(visitor)
        visitor.py_string(self)
      end

      def report_to(listener)
        listener.py_string(@content, @line)
      end

      def to_s
        @content.gsub(/\\"/, '"')
      end
      
      def to_execution_format
        to_s
      end

      def interpolate(hash) #:nodoc:
        string = @content
        hash.each do |key, value|
          value ||= ''
          string = string.gsub(/<#{key}>/, value)
        end
        self.class.new(string, @line)
      end

      def has_text?(text)
        @content.index(text)
      end      
    end
  end
end
