module Vestige
  class Faraday < ::Faraday::Middleware
    X_REQUEST_ID = "X-Request-Id".freeze

    def call(env)
      env[:request_headers].merge!(X_REQUEST_ID => Vestige.trace_id)
      @app.call(env)
    end
  end
end

if Faraday::Middleware.respond_to?(:register_middleware)
  Faraday::Request.register_middleware(vestige: lambda { Vestige::Faraday })
end
