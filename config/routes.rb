Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'posts#index'
  get '/admin', to: 'session#create'
  get '/area/:id', to: 'areas#show'

end
