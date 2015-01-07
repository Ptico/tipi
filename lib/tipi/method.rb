module Tipi
  class Method
    @registry = {}

    class << self
      def [](verb)
        @registry[verb]
      end

      def fetch(verb, *args, &block)
        @registry.fetch(verb.to_s.upcase, *args, &block)
      end

      def register(verb, safe: false, idempotent: false, cacheable: false, allows_body: true)
        verb = verb.to_s.upcase.freeze
        meth = new(verb, safe, idempotent, cacheable, allows_body)

        rubified_verb = verb.gsub('-', '_')
        const_set(rubified_verb, meth)
        @registry[verb] = meth

        name = "#{rubified_verb.downcase}?"

        class_eval(<<-METH, __FILE__, __LINE__+1)
          def #{name}
            @verb == "#{verb}"
          end
        METH
      end

      def registered?(verb)
        @registry.has_key?(verb.to_s.upcase)
      end

      def all
        @registry.values
      end
    end

    private_class_method :new

    ##
    # Request verb
    #
    # Returns: {String}
    #
    attr_reader :verb

    attr_reader :to_sym

    alias :to_s :verb

    ##
    # Request methods are considered "safe" if their defined semantics are essentially read-only;
    # i.e., the client does not request, and does not expect, any state change on the origin server
    # as a result of applying a safe method to a target resource. Likewise, reasonable use of a
    # safe method is not expected to cause any harm, loss of property, or unusual burden on
    # the origin server
    #
    # Returns: {Boolean} true if this method is safe
    #
    def safe?
      @safe
    end

    ##
    # Request methods are considered "idempotent" if the intended effect of multiple identical
    # requests is the same as for a single request. Of the request methods defined by this
    # specification, the PUT, DELETE, and safe request methods are idempotent.
    #
    # Returns: {Boolean} true if this method idempontent
    #
    def idempotent?
      @idempotent
    end

    ##
    # Request methods are considered "cacheable" if it is possible and useful to answer a current
    # client request with a stored response from a prior request. GET and HEAD are defined to be
    # cacheable.
    #
    # Returns: {Boolean} true if this method cacheable
    #
    def cacheable?
      @cacheable
    end

    ##
    # Returns: {Boolean} false if entity body MUST not be present in the response
    #
    def allows_body?
      @allows_body
    end

    ##
    # Inspect
    #
    def inspect
      "#<Tipi::Method::#{@verb} safe=#{@safe} idempotent=#{@idempotent} cacheable=#{@cacheable}>"
    end

  private

    def initialize(verb, safe, idempotent, cacheable, allows_body)
      @verb = verb
      @safe = safe
      @idempotent  = idempotent
      @cacheable   = cacheable
      @allows_body = allows_body

      @to_sym = verb.downcase.to_sym

      freeze
    end

  end

  Method.register('GET', safe: true, idempotent: true, cacheable: true)
  Method.register('POST')
  Method.register('PUT', idempotent: true)
  Method.register('PATCH')
  Method.register('DELETE', idempotent: true)
  Method.register('HEAD', safe: true, idempotent: true, cacheable: true, allows_body: false)
  Method.register('TRACE', safe: true, idempotent: true, allows_body: false)
  Method.register('OPTIONS', safe: true, idempotent: true)
  Method.register('LINK', idempotent: true)
  Method.register('UNLINK', idempotent: true)
end
