module Weather
  module V1
    class CurrentConditions < Weather::API
      resources :weather do
        get :current do
          { message: 'Hello Grape' }
        end
      end
    end
  end
end
