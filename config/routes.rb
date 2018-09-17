Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'posts#index'

  resources :posts

  get 'admin', to: 'sessions#new'
  post 'admin', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'youtubeAPI', to: 'posts#get_youtube_videos'
  get 'search', to: 'posts#search'                      # 検索
  
  get '/area/:id', to: 'areas#show'


end
