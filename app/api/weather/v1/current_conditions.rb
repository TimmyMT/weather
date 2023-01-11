module Weather
  module V1
    class CurrentConditions < Weather::API
      resources :weather do
        get '/current' do
          result = AccuWeather.current_temperature

          result.first["Temperature"]
        end

        get '/historical' do
          AccuWeather.day_conditions
        end

        get '/historical/max' do
          AccuWeather.temperature_by_day('max')
        end

        get '/historical/min' do
          AccuWeather.temperature_by_day('min')
        end

        get '/historical/avg' do
          AccuWeather.temperature_by_day('avg')
        end

        params { requires :epoch_time, type: Integer }
        get '/by_time' do
          result = AccuWeather.temperature_by_time(params[:epoch_time])

          if !result.empty?
            result.first["Temperature"]
          else
            status 404
            { error: "Conditions not found" }
          end
        end
      end
    end
  end
end
