class UpdateMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, chat_number, message_number, params)
        @application = Application.where(token: application_token)[0]
        @chat = Chat.where(application_id: @application.id, number: chat_number)[0]
        @chat.messages.where(chat_id: @chat.id, number: message_number).update(params)
    end
end
