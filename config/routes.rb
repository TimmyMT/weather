Rails.application.routes.draw do
  resources :health, only: :index
  resources :weather do
    collection do
      get :current
      get :historical
      get "/historical/max", to: 'weather#max'
      get "/historical/min", to: 'weather#min'
      get "/historical/avg", to: 'weather#avg'
      get :by_time
    end
  end
end
