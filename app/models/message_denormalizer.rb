class MessageDenormalizer
    attr_reader :message
    attr_reader :chat
    attr_reader :application

    def initialize(message)
        @message = message
        @chat = message.chat
        @application = chat.application
    end

    def to_hash
        %w[
            number
            body
            chat_number
            chat_title
            application_token
            application_name
        ]
        .map { |method_name| [method_name, send(method_name)] }.to_h
    end


    def number
        message.number
    end

    def body
        message.body
    end

    def chat_number
        chat.number
    end

    def chat_title
        chat.title
    end

    def application_token
        application.token
    end

    def application_name
        application.name
    end

end