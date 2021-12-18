class DatabaseUpdateWorker
  include Sidekiq::Worker
  def perform
    puts "update database count"
    Application.all.each do |application|
      application.update(chats_count: application.chats.size)
      application.chats.all.each do |chat|
        chat.update(messages_count: chat.messages.size)
      end
  end
  end
end

