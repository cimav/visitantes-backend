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

end
