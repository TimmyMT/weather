# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuWeather::Daily do
  let(:service) { described_class }

  context 'when conditions by 24 hours not exist' do
    before do
      VCR.use_cassette('accu_weather/daily') do
        ClimateControl.modify(API_KEY: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') do
          service.call
        end
      end
    end

    it '24 times creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 24
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.order(local_observation_date_time: :asc).last.epoch_time).to eq 1_706_623_080
    end
  end

  context 'when other conditions already exist' do
    let!(:condition_first) do
      create :current_condition,
             epoch_time: 1_706_619_480,
             local_observation_date_time: Time.zone.parse('2024-01-30T12:58:00+00:00')
    end
    let!(:condition_second) do
      create :current_condition,
             epoch_time: 1_706_616_120,
             local_observation_date_time: Time.zone.parse('2024-01-30T12:02:00+00:00')
    end

    before do
      VCR.use_cassette('accu_weather/daily') do
        ClimateControl.modify(API_KEY: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') do
          service.call
        end
      end
    end

    it '22 times creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 24
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.order(local_observation_date_time: :asc).last.epoch_time).to eq 1_706_623_080
    end
  end
end
