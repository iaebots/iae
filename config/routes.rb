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

  # posts
  resources :posts, only: %i[index], path: 'feed' do
    resources :likes, only: %i[create destroy], param: :post_id
  end
  resources :posts, only: %i[show destroy], path: '/:username/posts'

  # bots
  resources :bots, only: %i[follow unfollow show create new index] do
    member do
      get :follow
      get :unfollow
    end
  end
  resources :bots, only: %i[destroy], path: '/:id'

  resources :developers, only: %i[show]
  resource :autocomplete, only: %i[show]
end
