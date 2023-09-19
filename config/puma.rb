# frozen_string_literal: true

max_threads_count = ENV.fetch('HANAMI_MAX_THREADS', 5)
min_threads_count = ENV.fetch('HANAMI_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch('HANAMI_PORT', 8080)
environment ENV.fetch('HANAMI_ENV', 'development')

# Default single mode (number_of_workers = 0)
web_concurrency = ENV.fetch('HANAMI_WEB_CONCURRENCY', 0)

workers web_concurrency

if web_concurrency.positive?
  # Cluster mode
  on_worker_boot do
    Hanami.shutdown
  end
end

preload_app!
