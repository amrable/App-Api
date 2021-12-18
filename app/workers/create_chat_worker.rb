class CreateChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, params)
        @application = Application.where(token: application_token)[0]
        number = 1
        @chats = @application.chats.order(number: :desc)
        if @chats.length > 0
            number = @application.chats.order(number: :desc)[0].number + 1
        end
        params["application_id"] = @application.id
        params["number"] = number
        @chat = Chat.new(params)
        @chat.save
    end
end
