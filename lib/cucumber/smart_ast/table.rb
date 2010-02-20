module Cucumber
  module SmartAst
    class Table
      include Enumerable
      
      attr_reader :raw, :line

      def initialize(raw, line)
        @raw, @line = raw, line
      end

      def interpolate(hash)
        self # TODO: actually do it
      end

      def accept(visitor)
        visitor.step_table(self)
      end

      def report_to(listener)
        listener.table(@raw, @line)
      end

      def to_execution_format
        self
      end

      def headers
        @raw.first
      end
      
      def rows
        @raw[1..-1]
      end
      
      def columns
        @raw.transpose
      end
              
      def each(&block)
        rows.each do |row|
          yield row
        end
      end
      
      def hashes
        @hashes ||= collect do |row|
          hash_of(row)
        end
      end
      
      def transpose
        self.class.new(columns, @line)
      end
            
      def rows_hash
        return @rows_hash if @rows_hash
        verify_table_width(2)
        @rows_hash = self.transpose.hashes[0]
      end
            
      private
      
      def hash_of(row)
        hash = Hash.new { |h, k| h[k.to_s] if k.is_a? Symbol }
        headers.zip(row).each do |k, v|
          hash[k] = v
        end
        hash
      end
      
      def verify_table_width(width) #:nodoc:
        raise %{The table must have exactly #{width} columns} unless raw[0].size == width
      end      
    end
  end
end
