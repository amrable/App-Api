class CreateMessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, chat_number, params)
        @application = Application.where(token: application_token)[0]
        @chat = Chat.where(application_id: @application.id, number: chat_number)[0]
        @messages = @chat.messages.order(number: :desc)
        number = 1
        if @messages.length > 0
            number = @messages.first.number + 1
        end
        params["chat_id"] = @chat.id
        params["number"] = number
        @message = Message.new(params)
        @message.save
    end
end
