module Tipi
  class Status
    TYPES = {
      1 => :informational,
      2 => :successful,
      3 => :redirection,
      4 => :client_error,
      5 => :server_error
    }.freeze

    class << self
      def type(status)
        TYPES[status.to_i / 100]
      end
    end
  end
end
