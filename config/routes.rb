Rails.application.routes.draw do
  resources :participants do
  	collection do
  		get 'scheduled_meeting'
  		post 'add_more'
  	end
  end
  root 'participants#index'
end
