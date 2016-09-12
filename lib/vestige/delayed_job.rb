module Vestige
  module DelayedJob
    class Plugin < ::Delayed::Plugin
      callbacks do |lifecycle|
        lifecycle.around(:invoke_job) do |job, *args, &block|
          begin
            Vestige.trace_id = job.trace_id
            if Rails.logger.respond_to?(:tagged)
              Rails.logger.tagged(Vestige.trace_id, "delayed_job") { block.call(job, *args) }
            else
              block.call(job, *args)
            end
          ensure
            Vestige.trace_id = nil
          end
        end

        lifecycle.before(:enqueue) do |job, *_args, &_block|
          job.trace_id = Vestige.trace_id
        end
      end
    end
  end
end

Delayed::Worker.plugins << Vestige::DelayedJob::Plugin
