module Weather
  module V1
    class Health < Weather::API
      resources :health do
        get do
          status :ok
        end
      end
    end
  end
end
