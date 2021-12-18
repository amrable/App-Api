class CreateChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, params)
        @application = Application.where(token: application_token)[0]
        params["application_id"] = @application.id
        @chat = Chat.new(params)
        @chat.save
    end
end
