Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  resources :users
  
end
