ENV["REDIS_URL"] ||= "redis://127.0.0.1:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"], namespace: 'sidekiq' }
end
