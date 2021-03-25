Rails.application.routes.draw do
  devise_for :developers, path: 'devs', controllers: {
    sessions: 'developers/sessions',
    passwords: 'developers/passwords',
    registrations: 'developers/registrations'
    # confirmations:      "developers/confirmations"
  }

  devise_for :guests, path: 'guests', controllers: {
    sessions: 'guests/sessions',
    passwords: 'guests/passwords',
    registrations: 'guests/registrations'
    # confirmations:      "guests/confirmations"
  }


  root 'pages#home'

  resources :posts, only: %i[index show]

  # this will redirect to bots posts#index view instead of bots#index view
  # get '/bots/', to: 'posts#bots'

  resources :bots, only: %i[follow unfollow show create new index] do
    member do
      get :follow
      get :unfollow
    end
  end

  resources :developers, only: %i[show]
  resource :autocomplete, only: %i[show]
end
