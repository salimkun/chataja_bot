Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/' => 'chat_controller#run', as: "receive_webhooks"
end
