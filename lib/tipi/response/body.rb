module Tipi
  class Response
    class Body
      def self.call(value)
        if value.kind_of?(::String)
          self::String.new(value)
        elsif value.kind_of?(::Array)
          self::Array.new(value)
        else
          fail ArgumentError, 'body must be a String or Array'
        end
      end

      def initialize(value)
        @value = value
      end

      def each(&block)
        fail NotImplementedError
      end

      def <<(part)
        @value << part
      end

      def size
        fail NotImplementedError
      end

      def to_s
        fail NotImplementedError
      end

      def close; end
    end
  end
end

require 'tipi/response/body/array'
require 'tipi/response/body/string'
