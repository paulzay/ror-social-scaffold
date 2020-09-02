Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  get 'friends', to: 'friendships#index'
  get 'add_friend', to: 'friendships#create'
  get 'accept_request', to: 'friendships#accept'
  delete 'deny_request', to: 'friendships#deny'
  delete 'delete_friend', to: 'friendships#destroy'
 
end
