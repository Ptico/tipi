module Tipi
  ##
  # Class: an HTTP header representation
  #
  # https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
  # https://tools.ietf.org/html/rfc7234#section-5
  #
  class Header
    @registry = {}

    EOF = "\r\n".freeze

    class << self
      ##
      # Static: Create header with given name.
      #
      # Params:
      # - name {String} Header-Name
      #
      # Returns: {Tipi::Header} default (string) or typed
      # representation if header name is registered by Tipi::Header.register
      #
      # Examples:
      #
      #     Tipi::Header['X-Header'] # => #<Tipi::Header ...>
      #     Tipi::Header['Expires'] # => #<Tipi::Header::DateTime ...>
      #     Tipi::Header['Cache-Control'] # => #<Tipi::Header::Cache-Control ...>
      #
      def [](name)
        if klass = @registry[name]
          klass
        else
          self
        end.new(name) # TODO - Normalize name: x-content -> X-Content
      end

      ##
      # Static: Register header type
      #
      def register(name, klass)
        @registry[name] = klass
      end
    end

    ##
    # Header name (field-name)
    #
    # Returns: {String}
    #
    attr_reader :name

    ##
    # Typed header value
    #
    attr_reader :value

    ##
    # Set header value from their native type
    #
    # Params:
    # - val Typed header value
    #
    def set(val)
      @value = val
      @http_value = nil
      self
    end

    ##
    # Add header value if multiple values allowed
    #
    def add(val)

    end

    ##
    # Set header value from raw HTTP string
    #
    # Params:
    # - field_value {String} raw HTTP value
    #
    def call(field_value)
      @http_value = field_value.to_s
      self
    end

    def value
      @value ||= parse_http_string(@http_value)
    end

    ##
    # Raw HTTP value (field-value)
    #
    # Returns: {String}
    #
    def http_value
      @http_value ||= build_http_string(@value)
    end

    def to_http_string
      "#{name}: #{http_value}#{EOF}"
    end

    def to_s
      "#{name}: #{http_value}"
    end

  private

    ##
    # Constructor:
    #
    # Params:
    # - name {String} Header name
    #
    def initialize(name)
      @name  = name.freeze
      @value = nil
    end

    ##
    # Parse raw HTTP string
    #
    # Params:
    # - val {String} HTTP string value
    #
    def parse_http_string(val)
      val.to_s
    end

    ##
    # Build raw HTTP string from typed value
    #
    # Returns: {String}
    #
    def build_http_string(val)
      val.to_s
    end
  end
end

require 'tipi/header/digit'
require 'tipi/header/date_time'
