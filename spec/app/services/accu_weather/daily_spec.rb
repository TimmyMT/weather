require 'rails_helper'

RSpec.describe AccuWeather::Daily do
  let(:service) { described_class }
  let(:context_url) { 'currentconditions/v1/329260/historical/24' }
  let(:body) { File.open('spec/support/files/historical.json') }
  let(:frozen_time) { Time.zone.parse("2023-01-11T11:48:00+00:00") }

  before do
    Timecop.travel(frozen_time)
    mock_request(context_url, body)
  end

  context 'when conditions by 24 hours not exist' do
    before { service.call }
    
    it '24 times creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 24
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.order(local_observation_date_time: :asc).last.epoch_time).to eq 1673438280
    end
  end

  context 'when other conditions already exist' do
    let!(:condition_first) {
      create :current_condition,
      epoch_time: 1673355420,
      local_observation_date_time: Time.zone.parse("2023-01-10T12:57:00+00:00")
    }
    let!(:condition_second) {
      create :current_condition,
      epoch_time: 1673359320,
      local_observation_date_time: Time.zone.parse("2023-01-10T14:02:00+00:00")
    }

    before { service.call }

    it '24 times creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 24
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.order(local_observation_date_time: :asc).last.epoch_time).to eq 1673438280
    end
  end
end
