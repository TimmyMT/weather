module Weather
  module V1
    class CurrentConditions < Weather::Base
      formatter :json, Grape::Formatter::ActiveModelSerializers

      resources :weather do
        get '/current' do
          CurrentCondition.order(local_observation_date_time: :asc).last
        end

        namespace '/historical' do
          before do
            @collection = CurrentCondition.order(local_observation_date_time: :asc).last(24)
          end

          get '/' do
            @collection
          end
  
          get '/max' do
            Calculations::TemperatureByDay.new(@collection, 'max').call
          end
  
          get '/min' do
            Calculations::TemperatureByDay.new(@collection, 'min').call
          end
  
          get '/avg' do
            Calculations::TemperatureByDay.new(@collection, 'avg').call
          end
        end

        params { requires :epoch_time, type: Integer }
        get '/by_time' do
          condition = CurrentCondition.order(Arel.sql("ABS(epoch_time - #{params[:epoch_time].to_i}) ASC")).first

          if condition.present?
            condition
          else
            status :not_found
            { error: 'Conditions not found' }
          end
        end
      end
    end
  end
end
