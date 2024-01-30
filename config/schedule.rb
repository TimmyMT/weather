# frozen_string_literal: true

# Learn more: http://github.com/javan/whenever

every 1.hour do
  runner 'AccuWeather::Current.call'
end

every 1.day, at: '23:55 am' do
  runner 'AccuWeather::Daily.call'
end
