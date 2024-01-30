# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuWeather::Current do
  let(:service) { described_class }
  let(:context_url) { 'currentconditions/v1/329260' }
  let(:body) { File.open('spec/support/files/current.json') }
  let(:frozen_time) { Time.zone.parse('2023-01-11T11:48:00+00:00') }

  before do
    Timecop.travel(frozen_time)
    mock_request(context_url, body)
  end

  context 'when current condition not exist' do
    before { service.call }

    it 'creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 1
    end

    it 'creates CurrentCondition with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1_673_437_680
    end
  end

  context 'when CurrentCondition already exist' do
    let!(:current_condition) do
      create :current_condition,
             epoch_time: 1_673_437_680,
             local_observation_date_time: frozen_time,
             expires: frozen_time
    end

    before { service.call }

    it 'not creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 1
    end

    it 'last CurrentCondition must be with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1_673_437_680
    end
  end

  context 'when CurrentCondition expires' do
    let!(:current_condition) do
      create :current_condition,
             epoch_time: 1_673_437_679,
             local_observation_date_time: frozen_time - 1.hour,
             expires: frozen_time - 1.hour
    end

    before { service.call }

    it 'not creates CurrentCondition' do
      expect(CurrentCondition.count).to eq 2
    end

    it 'last CurrentCondition must be with expected data' do
      expect(CurrentCondition.last.epoch_time).to eq 1_673_437_680
    end
  end
end
