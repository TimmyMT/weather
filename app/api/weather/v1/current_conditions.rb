module Weather
  module V1
    class CurrentConditions < Weather::API
      resources :weather do
        get '/current' do
          last_current_condition = CurrentCondition.order(local_observation_date_time: :asc).last

          last_current_condition.content['Temperature']
        end

        namespace do
          before do
            @collection = CurrentCondition.order(local_observation_date_time: :asc).last(24)
          end

          get '/historical' do
            @collection.pluck(:content).pluck('LocalObservationDateTime', 'Temperature')
          end
  
          get '/historical/max' do
            Calculations::TemperatureByDay.new(@collection, 'max').call
          end
  
          get '/historical/min' do
            Calculations::TemperatureByDay.new(@collection, 'min').call
          end
  
          get '/historical/avg' do
            Calculations::TemperatureByDay.new(@collection, 'avg').call
          end
        end

        params { requires :epoch_time, type: Integer }
        get '/by_time' do
          current_condition = CurrentCondition.find_by(epoch_time: params[:epoch_time])

          if current_condition.present?
            current_condition.content['Temperature']
          else
            status :not_found
            { error: 'Conditions not found' }
          end
        end
      end
    end
  end
end
