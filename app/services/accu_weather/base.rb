# frozen_string_literal: true

module AccuWeather
  class Base
    LOCATION_KEY = 329_260
    API_URL = 'http://dataservice.accuweather.com'

    def self.client_req(url)
      result = RestClient.get "#{url}?apikey=#{ENV['API_KEY']}"
      JSON.parse(result)
    end

    def self.condition_exist?(condition)
      CurrentCondition.find_by(
        epoch_time: condition['EpochTime'],
        local_observation_date_time: Time.zone.parse(condition['LocalObservationDateTime'])
      ).present?
    end
  end
end
