Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'posts#index'
  get '/admin', to:'regions#index'

  resources :regions, :only => [:index, :create, :update, :destroy]
  resources :areas, :only => [:index, :create, :update, :destroy]
  resources :rocks, :only => [:index, :create, :update, :destroy]
  resources :problems, :only => [:index, :create, :update, :destroy]
  resources :posts, :only => [:index, :create, :update]

  get 'admin', to: 'admin#index'

  get 'suggest_regions', to: 'search#suggest_regions'
  get 'suggest_areas', to: 'search#suggest_areas'
  get 'suggest_problems', to: 'search#suggest_problems'
  get '/increment_hits', to: 'posts#increment_hits'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'search', to: 'posts#search'

  post '/set_refine_search', to: 'posts#set_refine_search'

end
