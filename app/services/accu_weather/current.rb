class AccuWeather::Current < AccuWeather::Base
  def self.call
    url = "#{API_URL}/currentconditions/v1/#{LOCATION_KEY}"
    result = client_req(url)

    return unless current_condition_expires?
    return if condition_exist?(result.first)

    CurrentCondition.create(
      epoch_time: result.first['EpochTime'],
      local_observation_date_time: Time.zone.parse(result.first['LocalObservationDateTime']),
      content: result.first
    )
  end

  private

  def self.current_condition_expires?
    last = CurrentCondition.order(local_observation_date_time: :asc).last
    return true if last.nil?

    last.local_observation_date_time.hour < Time.current.hour
  end
end
