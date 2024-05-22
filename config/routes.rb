Rails.application.routes.draw do

  root 'home#index'
  get 'os_controls/:os', to: 'os_controls#show', as: 'os_controls'
  post 'os_controls/generate', to: 'os_controls#generate', as: 'generate_controls'
  # get 'os_controls/show'
  # get 'os_controls/generate'
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
