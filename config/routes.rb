Rails.application.routes.draw do
  resources :visitantes
  resources :visitas
  resources :empleados

  get '/visitantes/avatar/:id', to: 'visitantes#avatar'
  get '/visitas_adentro/:sede', to: 'visitas#adentro'
  get '/count', to: 'visitantes#count'
  get '/visitantes/last/:id', to: 'visitantes#last'
  get '/visitas/last/:visitante_id', to: 'visitas#last'

end
