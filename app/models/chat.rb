class Chat < ApplicationRecord
  has_many :messages
  belongs_to :application
  before_create :set_defaults

  def set_defaults
    self.messages_count = 0
  end
end
