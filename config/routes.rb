Rails.application.routes.draw do
  root "staticpages#landing"
  get '/dashboard', to: "admin#dashboard"
  get '/find_team', to: "teams#find"
  post '/find_team', to: "teams#team_finder"
  resources :submissions, only: [:create, :index, :update]
  get '/latest-submission', to: 'submissions#latest_submission'
  put '/update_accept',     to: 'submissions#update_accept'

  resources :teams, only: [:create, :show, :index]
  put '/teams/:slug',         to: 'teams#update'
  put '/next_location/:slug', to: 'teams#next_location'
  get '/team_data/:slug',     to: 'teams#team_data'

  resources :hunts, only: [:create, :index]
  delete '/end_hunt', to: 'hunts#destroy'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
