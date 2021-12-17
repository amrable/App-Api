class CreateApplicationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
        @application = Application.new(params)
        @application.save
    end
end