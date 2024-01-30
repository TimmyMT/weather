require 'rails_helper'

RSpec.describe Calculations::TemperatureByDay do
  let(:service) { described_class.new(collection, setting) }

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

  context do
    let(:collection) { CurrentCondition.order(local_observation_date_time: :asc).last(24) }

    before { service.call }

    context 'when setting is max' do
      let(:setting) { 'max' }
      
      it 'return max values' do
        expect(service.call).to eq(
          {
            "Metric" => { "Value" => 35, "Unit" => "C", "UnitType" => 17 },
            "Imperial" => { "Value" => 49, "Unit" => "F", "UnitType" => 18 }
          }
        )
      end
    end

    context 'when setting is min' do
      let(:setting) { 'min' }
      
      it 'return max values' do
        expect(service.call).to eq(
          {
            "Metric" => { "Value" => 12, "Unit" => "C", "UnitType" => 17 },
            "Imperial" => { "Value" => 26, "Unit" => "F", "UnitType" => 18 }
          }
        )
      end
    end

    context 'when setting is avg' do
      let(:setting) { 'avg' }
      
      it 'return max values' do
        expect(service.call).to eq(
          {
            "Metric" => { "Value" => 23, "Unit" => "C", "UnitType" => 17 },
            "Imperial" => { "Value" => 37, "Unit" => "F", "UnitType" => 18 }
          }
        )
      end
    end
  end
end
