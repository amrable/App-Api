Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web  => "/sidekiq"
  resources :applications, param: :token do
    resources :chats, param: :number do
      resources :messages
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
