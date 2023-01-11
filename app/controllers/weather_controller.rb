class WeatherController < ApplicationController
  def current
    result = AccuWeather.current_temperature

    render json: result.first["Temperature"]
  end

  def historical
    result = AccuWeather.day_conditions

    render json: result
  end

  def max
    result = AccuWeather.temperature_by_day('max')

    render json: result
  end

  def min
    result = AccuWeather.temperature_by_day('min')

    render json: result
  end

  def avg
    result = AccuWeather.temperature_by_day('avg')

    render json: result
  end

  def by_time
    result = AccuWeather.temperature_by_time(params[:epoch_time])

    if !result.empty?
      render json: result.first["Temperature"]
    else
      render status: :not_found
    end
  end
end
