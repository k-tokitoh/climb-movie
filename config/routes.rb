Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'posts#index'

  resources :posts
  
  get 'admin', to: 'admin#index'
  
  get '/regions/:id', to: 'admin#show_areas'
  post '/regions', to: 'admin#create_region', as: 'regions'
  patch '/regions/:id', to: 'admin#edit_region', as: 'region'
  delete '/regions/:id', to: 'admin#destroy_region'
  
  get '/areas/:id', to: 'admin#show_rocks'
  post '/areas', to: 'admin#create_area', as: 'areas'
  patch '/areas/:id', to: 'admin#edit_area', as: 'area'
  delete '/areas/:id', to: 'admin#destroy_area'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'youtubeAPI', to: 'posts#get_youtube_videos'
  get 'search', to: 'posts#search'                      # 検索
  
  post '/set_refine_search', to: 'posts#set_refine_search'


end
