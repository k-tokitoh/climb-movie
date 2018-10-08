Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'posts#index'
  get '/admin', to:'regions#index'

  resources :regions
  resources :areas
  resources :rocks
  resources :problems
  resources :posts
  
  get 'admin', to: 'admin#index'
  
  get 'suggest_areas', to: 'search#suggest_areas'
  get 'suggest_problems', to: 'search#suggest_problems'
  get '/increment_hits', to: 'posts#increment_hits'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # get '/posts/ajax_test'

  get 'youtubeAPI', to: 'posts#get_youtube_videos'
  get 'search', to: 'posts#search'                      # 検索
  
  post '/set_refine_search', to: 'posts#set_refine_search'

end
