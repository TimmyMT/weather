class AccuWeather::Base
  LOCATION_KEY = 329260
  API_URL = 'http://dataservice.accuweather.com'

  private

  def self.client_req(url)
    result = RestClient.get "#{url}?apikey=#{Rails.application.credentials.api_key}"
    JSON.parse(result)
  end

  def self.condition_exist?(condition)
    CurrentCondition.find_by(
      epoch_time: condition['EpochTime'],
      local_observation_date_time: Time.zone.parse(condition['LocalObservationDateTime'])
    ).present?
  end
end
