require 'date'

module Tipi
  class Header
    ##
    # Class: an HTTP header which contains date (RFC 7231) value
    #
    # Example:
    #
    #     Date
    #     Expires
    #     If-Modified-Since
    #     If-Unmodified-Since
    #     Last-Modified
    #
    class DateTime < self
      ##
      # Parse raw HTTP string
      #
      # Params:
      # - val {String} HTTP string value
      #
      def parse_http_string(val)
        ::DateTime.parse(val)
      end

      ##
      # Build raw HTTP string from datetime value
      #
      # Params:
      # - val {DateTime, String, Integer} datetime, string representation or timestamp
      #
      # Returns: {String}
      #
      def build_http_string(val)
        case val
          when ::DateTime
            val.dup
          when ::String
            ::DateTime.parse(val)
          when ::Integer
            ::Time.at(val).to_datetime
        end.new_offset(0).strftime('%a, %d %b %Y %H:%M:%S GMT')
      end
    end

    register('Date', DateTime)
    register('Expires', DateTime)
    register('Last-Modified', DateTime)
    register('If-Modified-Since', DateTime)
    register('If-Unmodified-Since', DateTime)
  end
end
