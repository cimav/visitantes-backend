Rails.application.routes.draw do
  resources :visitantes
  resources :visitas
  resources :personas
  resources :main

  get '/visitantes/avatar/:id', to: 'visitantes#avatar'
  get '/visitas_adentro/:sede', to: 'visitas#adentro'
  get '/count', to: 'visitantes#count'
  get '/visitantes/last/:id', to: 'visitantes#last'
  get '/visitas/last/:visitante_id', to: 'visitas#last'
  get '/proveedores/:sede', to: 'personas#proveedores'

  resources :grid
  get 'main/index'
  get 'main/grid/:inicial/:final/:apellido/:empresa/:persona', to: 'main#grid'

  root to: 'main#index'
  #root :to => 'home#index'

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'sessions#failure', via: [:get, :post]
  match "/logout" => 'sessions#destroy', via: [:get, :post]
  match '/login' => 'login#index', via: [:get, :post]

=begin
  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get '/logout' => 'sessions#destroy'
=end

  # get '/visitas/delete/:id', to: 'visitas#delete'

end
