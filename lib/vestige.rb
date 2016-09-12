require "vestige/version"
require "vestige/rack"
require "vestige/net_http_patch"
require "vestige/railtie" if defined?(Rails.application)

%w(delayed_job sidekiq faraday).each do |lib|
  begin
    require lib
    require "vestige/#{lib}"
  rescue LoadError
  end
end

module Vestige
  TRACE_ID_KEY = "vestige_trace_id".freeze

  def self.trace_id
    Thread.current[TRACE_ID_KEY]
  end

  def self.trace_id=(trace_id)
    Thread.current[TRACE_ID_KEY] = trace_id
  end

  def self.patch_net_http!
    Net::HTTPGenericRequest.prepend(NetHttpPatch)
  end
end
