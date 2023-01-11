require 'rails_helper'

RSpec.describe AccuWeather::Current do
  let(:service) { AccuWeather::Current }
  let(:base_url) { "/api/v1/weather" }
  let(:context_url) { 'currentconditions/v1/329260' }
  let(:body) { File.open('spec/support/files/current.json') }

  before do
    mock_request(context_url, body)
  end

  context 'when current condition not exist' do
    before { service.call }
    
    it 'creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 1
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1673437680
    end
  end

  context 'when CurrentCondition already exist' do
    let!(:current_condition) do
      create :current_condition,
      epoch_time: 1673437680,
      local_observation_date_time: Time.zone.parse("2023-01-11T11:48:00+00:00")
    end

    before { service.call }

    it 'not creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 1
    end

    it 'last CurrentCondition must be with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1673437680
    end
  end

  context 'when CurrentCondition expires' do
    let!(:current_condition) do
      create :current_condition,
      epoch_time: 1673437679,
      local_observation_date_time: Time.zone.parse("2023-01-11T11:48:00+00:00") - 1.hour
    end

    before { service.call }

    it 'not creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 2
    end

    it 'last CurrentCondition must be with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1673437680
    end
  end
end
