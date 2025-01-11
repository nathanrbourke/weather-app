Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'forecasts#new'

  get 'forecasts/:postal_code', to: 'forecasts#show', as: 'forecast'
  resources :forecasts, only: %i[new create]
end
