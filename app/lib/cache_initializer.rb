class CacheInitializer

    def self.initiate_cache()
        Application.all.each do |application|
            REDIS.set(application.token, application.chats.size)
            application.chats.all.each do |chat|
                REDIS.set(application.token + "_" + chat.number.to_s , chat.messages.size)
            end
        end
    end
end