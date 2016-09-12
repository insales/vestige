module Vestige
  module Sidekiq
    class Client
      def call(_worker_class, job, _queue, _redis_pool = nil)
        job[TRACE_ID_KEY] = Vestige.trace_id
        yield
      end
    end

    class Server
      def initialize(logger = nil)
        @logger = logger
      end

      def call(_worker, msg, _queue)
        Vestige.trace_id = msg[TRACE_ID_KEY]
        current_logger.respond_to?(:tagged) ? current_logger.tagged(Vestige.trace_id, "sidekiq") { yield } : yield
      ensure
        Vestige.trace_id = nil
      end

      private

      def current_logger
        @logger || (Rails.logger if defined?(Rails.application)) || Sidekiq.logger
      end
    end

    class Formatter
      def call(severity, timestamp, _progname, msg)
        tag = Vestige.trace_id ? "[#{Vestige.trace_id}] " : ''
        "#{tag}#{timestamp.utc.iso8601} #{::Process.pid} TID-#{Thread.current.object_id.to_s(36)} #{severity}: #{msg}\n"
      end
    end
  end
end
