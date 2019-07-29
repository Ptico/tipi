module Tipi
  class Response

    def initialize
      yield if block_given?
    end

    ##
    # Set response status
    #
    # Params:
    # - response_status {Fixnum} status code
    #
    def status=(code)
      @status = code.kind_of?(Tipi::Status) ? code : Status[code.to_i]
    end

    ##
    # Set response body
    #
    def body=(response_body)
      @body = Body.call(response_body)
    end

    ##
    # Response headers
    #
    # Returns: {Tipi::Headers}
    #
    def headers

    end
  end
end

require 'tipi/response/body'
require 'tipi/response/headers'
