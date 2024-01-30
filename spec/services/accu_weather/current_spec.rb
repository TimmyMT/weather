# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuWeather::Current do
  let(:service) { described_class }

  before do
    VCR.use_cassette('accu_weather/current') do
      ClimateControl.modify(API_KEY: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') do
        service.call
      end
    end
  end

  context 'when current condition not exist' do
    it 'creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 1
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1_706_624_220
    end
  end
end
