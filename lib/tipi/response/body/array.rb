module Tipi
  class Response
    class Body
      class Array < self
        def each(&block)
          return @value.enum_for(:each) unless block_given?
          @value.each(&block)
          self
        end

        def size
          to_s.bytesize
        end

        def to_s
          @value.join
        end
      end
    end
  end
end
