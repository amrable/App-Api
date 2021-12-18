class AddLastRequestTimestampColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :last_request_timestamp, :timestamp
    add_column :chats, :last_request_timestamp, :timestamp
    add_column :messages, :last_request_timestamp, :timestamp
  end
end
