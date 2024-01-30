# frozen_string_literal: true

module AccuWeather
  class Daily < AccuWeather::Base
    def self.call
      url = "#{API_URL}/currentconditions/v1/#{LOCATION_KEY}/historical/24"
      result = client_req(url)

      result.each do |condition|
        next if condition_exist?(condition)

        CurrentCondition.create(
          epoch_time: condition['EpochTime'],
          local_observation_date_time: Time.zone.parse(condition['LocalObservationDateTime']),
          content: condition
        )
      end
    end
  end
end
