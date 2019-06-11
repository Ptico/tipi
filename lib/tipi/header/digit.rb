module Tipi
  class Header

    ##
    # Class: an HTTP header which contains digit value
    #
    # Example:
    #
    #     Age
    #     Content-Length
    #     Max-Forwards
    #
    class Digit < self
      ##
      # Parse raw HTTP string
      #
      # Params:
      # - val {String} HTTP string value
      #
      def parse_http_string(val)
        val.to_i
      end
    end
  end
end
