DjMon::Engine.routes.draw do

  resources :dj_reports do
    collection do
      get :all
      get :failed
      get :active
      get :queued
      get :dj_counts
      get :settings
      get :make_success
      get :make_fail
    end
    member do
      post :retry
    end
  end

  root :to => 'dj_reports#index'
end
