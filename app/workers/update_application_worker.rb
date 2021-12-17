class UpdateApplicationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, params)
        @application = Application.where(token: token)
        @application.update(params)
    end
end