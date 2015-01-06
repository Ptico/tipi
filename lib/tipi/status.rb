module Tipi
  class Status
    TYPES = {
      1 => :informational,
      2 => :successful,
      3 => :redirection,
      4 => :client_error,
      5 => :server_error
    }.freeze

    @registry = {}

    class << self
      def all
        @registry.values
      end

      def [](status)
        @registry[status]
      end

      def fetch(status, *args, &block)
        @registry.fetch(status.to_i, *args, &block)
      end

      def register(status, name, cacheable: false, allows_body: true)
        status = status.to_i

        @registry[status] = new(status, name, cacheable, allows_body)
      end

      def registered?(status)
        @registry.has_key?(status.to_i)
      end

      def type(status)
        TYPES[status.to_i / 100]
      end
    end

    attr_reader :code

    attr_reader :name

    attr_reader :type

    attr_reader :to_s

    alias :to_i :code

    def allows_body?
      @allows_body
    end

    def cacheable?
      @cacheable
    end

  private

    def initialize(code, name, cacheable, allows_body)
      @code = code
      @name = name
      @type = self.class.type(code)

      @cacheable   = cacheable
      @allows_body = allows_body

      @to_s = code.to_s

      freeze
    end

  end

  Status.register(100, 'Continue', allows_body: false)
  Status.register(101, 'Switching Protocols', allows_body: false)
  Status.register(102, 'Processing', allows_body: false)

  Status.register(200, 'OK', cacheable: true)
  Status.register(201, 'Created')
  Status.register(202, 'Accepted')
  Status.register(203, 'Non-Authoritative Information', cacheable: true)
  Status.register(204, 'No Content', cacheable: true, allows_body: false)
  Status.register(205, 'Reset Content', allows_body: false)
  Status.register(206, 'Partial Content', cacheable: true)
  Status.register(207, 'Multi-Status')
  Status.register(208, 'Already Reported')

  Status.register(300, 'Multiple Choices', cacheable: true)
  Status.register(301, 'Moved Permanently', cacheable: true)
  Status.register(302, 'Found')
  Status.register(303, 'See Other')
  Status.register(304, 'Not Modified', allows_body: false)
  Status.register(305, 'Use Proxy')
  Status.register(306, 'Reserved')
  Status.register(307, 'Temporary Redirect')
  Status.register(308, 'Permanent Redirect')

  Status.register(400, 'Bad Request')
  Status.register(401, 'Unauthorized')
  Status.register(402, 'Payment Required')
  Status.register(403, 'Forbidden')
  Status.register(404, 'Not Found', cacheable: true)
  Status.register(405, 'Method Not Allowed', cacheable: true)
  Status.register(406, 'Not Acceptable')
  Status.register(407, 'Proxy Authentication Required')
  Status.register(408, 'Request Timeout')
  Status.register(409, 'Conflict')
  Status.register(410, 'Gone', cacheable: true)
  Status.register(411, 'Length Required')
  Status.register(412, 'Precondition Failed')
  Status.register(413, 'Request Entity Too Large')
  Status.register(414, 'Request-URI Too Long', cacheable: true)
  Status.register(415, 'Unsupported Media Type')
  Status.register(416, 'Requested Range Not Satisfiable')
  Status.register(417, 'Expectation Failed')
  Status.register(422, 'Unprocessable Entity')
  Status.register(423, 'Locked')
  Status.register(424, 'Failed Dependency')
  Status.register(426, 'Upgrade Required')
  Status.register(428, 'Precondition Required')
  Status.register(429, 'Too Many Requests')
  Status.register(431, 'Request Header Fields Too Large')
  Status.register(451, 'Unavailable For Legal Reasons')

  Status.register(500, 'Internal Server Error')
  Status.register(501, 'Not Implemented', cacheable: true)
  Status.register(502, 'Bad Gateway')
  Status.register(503, 'Service Unavailable')
  Status.register(504, 'Gateway Timeout')
  Status.register(505, 'HTTP Version Not Supported')
  Status.register(506, 'Variant Also Negotiates (Experimental)')
  Status.register(507, 'Insufficient Storage')
  Status.register(508, 'Loop Detected')
  Status.register(510, 'Not Extended')
  Status.register(511, 'Network Authentication Required')
end
