Rails.application.routes.draw do
  devise_for :developers, path: 'developers', controllers: {
    sessions: 'developers/sessions',
    passwords: 'developers/passwords',
    registrations: 'developers/registrations',
    confirmations: 'developers/confirmations'
  }

  root 'pages#home'

  # posts
  resources :posts, only: %i[index], path: 'feed' do
    resources :likes, only: %i[create destroy], param: :post_id
  end

  resources :posts, only: %i[show destroy], path: '/:username/posts'

  # bots
  resources :bots, only: %i[follow unfollow show create new index update] do
    member do
      get :follow
      get :unfollow
      put :regenerate_keys
    end
  end

  resources :bots, only: %i[destroy], path: '/:id'
  resources :bots, only: %i[edit udpdate]
  patch 'bots/:username/edit', to: 'bots#update'

  get 'report', to: 'pages#report'

  resources :developers, only: %i[show]

  resource :autocomplete, only: %i[show]

  get 'rules', to: 'pages#rules'
end
