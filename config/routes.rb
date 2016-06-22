Rails.application.routes.draw do
  resources :participants
  root 'participants#index'
end
