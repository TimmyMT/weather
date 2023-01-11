# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CurrentConditions', type: :request do
  let(:base_url) { "/api/v1/weather" }
  let(:context_url) { 'currentconditions/v1/329260/historical/24' }
  let(:body) { File.open('spec/support/files/historical.json') }

  before do
    mock_request(context_url, body)
  end

  describe 'GET #current' do
    let(:context_url) { 'currentconditions/v1/329260' }
    let(:body) { File.open('spec/support/files/current.json').read }

    before do
      get "#{base_url}/current"
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return expected data' do
      expect(json['Metric']).to eq({ 'Value' => 7.0, 'Unit' => 'C', 'UnitType' => 17 })
    end
  end

  describe 'GET #historical' do
    before do
      get "#{base_url}/historical"
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return 24 results' do
      expect(json.count).to eq 24
    end

    it 'return expected data' do
      expect(json.first['Temperature']).to eq(
        {
          'Metric' => { 'Value' => 7, 'Unit' => 'C', 'UnitType' => 17 },
          'Imperial' => { 'Value' => 45, 'Unit' => 'F', 'UnitType' => 18 }
        }
      )
    end
  end

  describe 'GET #max' do
    before do
      get "#{base_url}/historical/max"
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return expected data' do
      expect(json).to eq(
        {
          'Metric' => { 'Value' => 11.8, 'Unit' => 'C', 'UnitType' => 17 },
          'Imperial' => { 'Value' => 53, 'Unit' => 'C', 'UnitType' => 18 }
        }
      )
    end
  end

  describe 'GET #min' do
    before do
      get "#{base_url}/historical/min"
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return expected data' do
      expect(json).to eq(
        {
          'Metric' => { 'Unit' => 'C', 'UnitType' => 17, 'Value' => 6 },
          'Imperial' => { 'Unit' => 'C', 'UnitType' => 18, 'Value' => 43 }
        }
      )
    end
  end

  describe 'GET #avg' do
    before do
      get "#{base_url}/historical/avg"
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return expected data' do
      expect(json).to eq(
        {
          'Metric' => { 'Unit' => 'C', 'UnitType' => 17, 'Value' => 8.55 },
          'Imperial' => { 'Unit' => 'C', 'UnitType' => 18, 'Value' => 47 }
        }
      )
    end
  end

  describe 'GET #by_time' do
    before do
      get "#{base_url}/by_time", { epoch_time: epoch_time }
    end

    context 'when condition exist' do
      let(:epoch_time) { 1673387880 }

      it 'return status Ok' do
        expect(last_response.status).to eq 200
      end
  
      it 'return expected data' do
        expect(json).to eq(
          {
            "Metric"=>{"Value"=>10, "Unit"=>"C", "UnitType"=>17},
            "Imperial"=>{"Value"=>50, "Unit"=>"F", "UnitType"=>18}
          }
        )
      end
    end

    context 'when condition not exist' do
      let(:epoch_time) { 1673387777 }

      it 'return status Not Found' do
        expect(last_response.status).to eq 404
      end
    end 
  end
end
