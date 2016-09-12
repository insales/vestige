module Vestige
  module NetHttpPatch
    X_REQUEST_ID = 'x-request-id'.freeze

    def initialize_http_header(initheader)
      super
      @header[X_REQUEST_ID] = Vestige.trace_id unless (@header.key?(X_REQUEST_ID) || Vestige.trace_id.nil?)
    end
  end
end
