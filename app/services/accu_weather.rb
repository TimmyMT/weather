class AccuWeather
  LOCATION_KEY = 329260
  API_URL = "http://dataservice.accuweather.com"

  def self.current_temperature
    url = "#{API_URL}/currentconditions/v1/#{LOCATION_KEY}"
    client_req(url)
  end

  def self.day_conditions
    url = "#{API_URL}/currentconditions/v1/#{LOCATION_KEY}/historical/24"
    client_req(url)
  end

  def self.temperature_by_day(condition)
    result = day_conditions
    
    met_val = result.pluck('Temperature').pluck("Metric").pluck("Value")
    imp_val = result.pluck('Temperature').pluck("Imperial").pluck("Value")
    
    metric = {
      "Value" => condition == 'avg' ? (met_val.sum / met_val.size).round(2) : eval("#{met_val}.#{condition}"),
      "Unit" => "C",
      "UnitType" => result.pluck('Temperature').pluck("Metric").first["UnitType"]
    }
    imperial = {
      "Value" => condition == 'avg' ? (imp_val.sum / imp_val.size).round(2) : eval("#{imp_val}.#{condition}"),
      "Unit" => "C",
      "UnitType" => result.pluck('Temperature').pluck("Imperial").first["UnitType"]
    }
    
    { "Metric" => metric, "Imperial" => imperial }
  end

  def self.temperature_by_time(epoch_time)
    result = day_conditions

    result.select { |condition| condition["EpochTime"] == epoch_time.to_i }
  end

  private

  def self.client_req(url)
    result = RestClient.get "#{url}?apikey=#{Rails.application.credentials.api_key}"
    JSON.parse(result)
  end
end
