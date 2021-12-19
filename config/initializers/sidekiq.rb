schedule_file = "config/schedule.yml"

sidekiq_config = { url: "redis://redis:6379/0" }
Sidekiq.configure_server do |config|
    config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
    config.redis = sidekiq_config
end

if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
