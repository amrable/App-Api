class CreateChatWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token)
        @application = Application.where(token: application_token)[0]
        number = 1
        @chats = @application.chats.order(number: :desc)
        if @chats.length > 0
            number = @application.chats.order(number: :desc)[0].number + 1
        end
        @chat = Chat.new(application_id: @application.id, number: number)
        @chat.save
    end
end
