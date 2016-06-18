Rails.application.routes.draw do
  delete '/session', to: 'echo#destroy_session'
  resources :echo, path: ':name', controller: :echo
  delete ':name', to: 'echo#destroy_all'
end
