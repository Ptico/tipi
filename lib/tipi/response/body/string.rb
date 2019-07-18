module Tipi
  class Response
    class Body
      class String < self
        def each(&block)
          return enum_for(:each) unless block_given?
          yield @value
          self
        end

        def size
          @value.bytesize
        end

        def to_s
          @value
        end
      end
    end
  end
end
