Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  root to: 'pull_requests#index'

  resources :pull_requests do
    collection do
      get :active
      post :payload
    end
  end
end
