Rails.application.routes.draw do
  root 'welcome#index'
  scope(path_names: { new: 'nouveau', edit: 'edition' }) do
    resources :projets, only: [:show, :edit, :update]
    get '/projets/:projet_id/invitations/operateur/:operateur_id', to: 'invitations#new', as: 'new_invitation'
    post '/projets/:projet_id/invitations/operateur/:operateur_id', to: 'invitations#create'
  end
  scope(path_names: { new: 'nouvelle' }) do
    resources :sessions, only: [:new, :create]
  end
end 
