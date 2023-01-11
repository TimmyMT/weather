module Weather
  class API < Grape::API
    format :json
    prefix :api
    version 'v1'

    mount Weather::V1::CurrentConditions
  end
end
