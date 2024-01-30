module Weather
  class Base < Grape::API
    format :json
    prefix :api
    version 'v1'

    mount Weather::V1::CurrentConditions
    mount Weather::V1::Health
  end
end
