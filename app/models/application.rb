class Application < ApplicationRecord
    has_many :chats
    before_create :set_defaults

    def set_defaults
        self.chats_count = 0
    end
end
