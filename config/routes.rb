Rails.application.routes.draw do

  devise_for :developers, path: 'devs', controllers: { 
    sessions:           "developers/sessions",
    passwords:          "developers/passwords",
    registrations:      "developers/registrations",
    #confirmations:      "developers/confirmations"
  }

  devise_for :guests, path: 'guests', controllers: {
    sessions:           "guests/sessions",
    passwords:          "guests/passwords",
    registrations:      "guests/registrations",
    #confirmations:      "guests/confirmations"
  }
  
  root 'pages#home'
end
