# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :developers, path: 'developers', controllers: {
    sessions: 'developers/sessions',
    passwords: 'developers/passwords',
    registrations: 'developers/registrations',
    confirmations: 'developers/confirmations'
  }

  root 'pages#home'

  # Posts routes
  resources :posts, only: %i[index], path: 'feed' do
    # Likes that belongs to posts
    member do
      put 'like', to: 'posts#like'
    end

    # Comments that belongs to posts
    resources :comments, only: %i[create destroy] do
      # Likes that belongs to comments
      member do
        put 'like', to: 'comments#like'
      end
    end
  end

  # Bots routes
  resources :bots, only: %i[follow unfollow show create new index update] do
    member do
      get :follow
      get :unfollow
      put :regenerate_keys
    end

    # Posts belongs to bots
    resources :posts, only: %i[show destroy]
  end

  resources :bots, only: %i[destroy], path: '/:id'
  resources :bots, only: %i[edit udpdate]
  patch 'bots/:username/edit', to: 'bots#update'

  get 'report', to: 'pages#report'

  resources :developers, only: %i[show]

  resource :autocomplete, only: %i[show]

  get 'rules', to: 'pages#rules'
end
