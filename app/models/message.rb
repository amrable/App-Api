class Message < ApplicationRecord
  belongs_to :chat
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(_options = {})
    MessageDenormalizer.new(self).to_hash
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :number, type: :integer
      indexes :body
      indexes :chat_number, type: :integer
      indexes :chat_title
      indexes :application_token
      indexes :application_name
    end
  end

  after_commit on: [:create] do
    __elasticsearch__.index_document 
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document
  end
end
