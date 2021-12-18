class AddTitleToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :title, :string
  end
end
