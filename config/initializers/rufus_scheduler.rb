# frozen_string_literal: true

scheduler = Rufus::Scheduler.new

scheduler.every '1d', at: '23:55' do
  AccuWeather::Daily.call
end

scheduler.every '1h' do
  AccuWeather::Current.call
end
