class UpdateChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, chat_number, params)
        @application = Application.where(token: application_token)[0]
        @chat = Chat.where(application_id: @application.id, number: chat_number)[0]
        if @chat.last_request_timestamp == nil or @chat.last_request_timestamp < params["last_request_timestamp"]
            @chat.update(params)
        end
    end
end
