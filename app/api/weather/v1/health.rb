module Weather
  module V1
    class Health < Weather::Base
      resources :health do
        get do
          status :ok
          { success: 'Server is running' }
        end
      end
    end
  end
end
