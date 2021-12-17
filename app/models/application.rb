class Application < ApplicationRecord
    before_create :set_defaults

    def set_defaults
        self.token = SecureRandom.uuid
        self.chats_count = 0
    end
end
