Rails.application.routes.draw do
  resources :messages
  resources :chats
  resources :applications, param: :token
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
