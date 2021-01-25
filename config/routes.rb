Rails.application.routes.draw do
  devise_for :developers, path: 'devs'
  devise_for :guests, path: 'guests'
  
  root 'pages#home'
end
