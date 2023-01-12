# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CurrentConditions', type: :request do
  let(:base_url) { "/api/v1/weather" }
  let(:frozen_time) { Time.zone.parse("2023-01-11T11:48:00+00:00") }

  describe 'GET #current' do
    let!(:current_condition) do
      create :current_condition,
      epoch_time: 1673437680,
      content: { 'Temperature' => {
          "Metric" => {
            "Value" => 7.0, "Unit" => "C", "UnitType" =>17
          }
        } 
      }
    end

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
    let!(:conditions_list) do
      create_list :current_condition, 23,
      epoch_time: rand(1673430000..1673439999),
      local_observation_date_time: frozen_time - 1.hour
    end
    let!(:last_condition) do
      create :current_condition,
      epoch_time: 1673440000,
      local_observation_date_time: frozen_time,
      content: { 
        'LocalObservationDateTime' => frozen_time,
        'Temperature' => {
          'Metric' => { 'Value' => 7, 'Unit' => 'C', 'UnitType' => 17 }
        } 
      }
    end

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
      expect(json.last['temperature']).to eq(
        {
          'Metric' => { 'Value' => 7, 'Unit' => 'C', 'UnitType' => 17 }
        }
      )
    end
  end

  context "historical" do
    before do
      for i in 11..34 do
        create :current_condition,
        epoch_time: "16734300#{i}".to_i,
        content: { 'Temperature' => {
            'Metric' => { 'Value' => 1 + i, 'Unit' => 'C', 'UnitType' => 17 },
            'Imperial' => { 'Value' => 15 + i, 'Unit' => 'F', 'UnitType' => 18 }
          } 
        }
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
            "Imperial" => { "Unit" => "F", "UnitType" => 18, "Value" => 49 },
            "Metric" => { "Unit" => "C", "UnitType" => 17, "Value"=> 35 },
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
            "Imperial" => { "Unit" => "F", "UnitType" => 18, "Value" => 26 },
            "Metric" => { "Unit" => "C", "UnitType" => 17, "Value"=> 12 },
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
            "Imperial" => { "Unit" => "F", "UnitType" => 18, "Value" => 37 },
            "Metric" => { "Unit" => "C", "UnitType" => 17, "Value"=> 23 },
          }
        )
      end
    end
  end

  describe 'GET #by_time' do
    context 'when condition exist' do
      let(:epoch_time) { 1673387880 }

      before do
        create :current_condition, epoch_time: epoch_time, content: {
          'Temperature' => {
            "Metric" => { "Value" => 10, "Unit" => "C", "UnitType" => 17 },
            "Imperial" => { "Value" => 50, "Unit" => "F", "UnitType" => 18 }
          }
        }
        get "#{base_url}/by_time", { epoch_time: epoch_time }
      end

      it 'return status Ok' do
        expect(last_response.status).to eq 200
      end
  
      it 'return expected data' do
        expect(json['temperature']).to eq(
          {
            "Metric"=>{"Value"=>10, "Unit"=>"C", "UnitType"=>17},
            "Imperial"=>{"Value"=>50, "Unit"=>"F", "UnitType"=>18}
          }
        )
      end
    end

    context 'when condition not exist' do
      let(:epoch_time) { 1673387777 }

      before do
        get "#{base_url}/by_time", { epoch_time: epoch_time }
      end

      it 'return status Not Found' do
        expect(last_response.status).to eq 404
      end
    end 
  end
end
