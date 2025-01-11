Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'forecasts#new'

  resources :forecasts, only: %i[new create show]
end
