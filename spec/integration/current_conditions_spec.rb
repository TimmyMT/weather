# frozen_string_literal: true

require 'swagger_helper'

describe 'current conditions API' do
  path '/api/v1/weather/current' do
    get 'returns current condition' do
      tags 'Current Conditions'
      operationId 'fetchCurrentCondition'
      produces 'application/json'

      let!(:current_condition) do
        create :current_condition,
               epoch_time: 1_673_437_680,
               content: { 'Temperature' => {
                 'Metric' => {
                   'Value' => 7.0, 'Unit' => 'C', 'UnitType' => 17
                 }
               } }
      end

      response '200', 'Found' do
        run_test! do
          expected_data = json['temperature']['Metric']

          expect(expected_data).to eq({ 'Value' => 7.0, 'Unit' => 'C', 'UnitType' => 17 })
        end
      end
    end
  end

  path '/api/v1/weather/historical' do
    get 'retrun conditions by last 24 hours' do
      tags 'Current Conditions'
      operationId 'fetchDayConditions'
      produces 'application/json'

      let(:frozen_time) { Time.zone.parse('2023-01-11T11:48:00+00:00') }
      let!(:conditions_list) do
        create_list :current_condition, 23,
                    epoch_time: rand(1_673_430_000..1_673_439_999),
                    local_observation_date_time: frozen_time - 1.hour
      end
      let!(:last_condition) do
        create :current_condition,
               epoch_time: 1_673_440_000,
               local_observation_date_time: frozen_time,
               content: {
                 'LocalObservationDateTime' => frozen_time,
                 'Temperature' => {
                   'Metric' => { 'Value' => 7, 'Unit' => 'C', 'UnitType' => 17 }
                 }
               }
      end

      response '200', 'Found' do
        run_test! 'return 24 items' do
          expect(json.count).to eq 24
        end

        run_test! 'return expected data' do
          expect(json.last['temperature']).to eq(
            {
              'Metric' => { 'Value' => 7, 'Unit' => 'C', 'UnitType' => 17 }
            }
          )
        end
      end
    end
  end

  context 'historical' do
    before do
      (11..34).each do |i|
        create :current_condition,
               epoch_time: "16734300#{i}".to_i,
               content: { 'Temperature' => {
                 'Metric' => { 'Value' => 1 + i, 'Unit' => 'C', 'UnitType' => 17 },
                 'Imperial' => { 'Value' => 15 + i, 'Unit' => 'F', 'UnitType' => 18 }
               } }
      end
    end

    path '/api/v1/weather/historical/max' do
      get 'returns current condition with max value' do
        tags 'Current Conditions'
        operationId 'fetchConditionMaxValue'
        produces 'application/json'

        response '200', 'Found' do
          run_test! 'return expected data' do
            expect(json).to eq(
              {
                'Imperial' => { 'Unit' => 'F', 'UnitType' => 18, 'Value' => 49 },
                'Metric' => { 'Unit' => 'C', 'UnitType' => 17, 'Value' => 35 }
              }
            )
          end
        end
      end
    end

    path '/api/v1/weather/historical/min' do
      get 'returns current condition with min value' do
        tags 'Current Conditions'
        operationId 'fetchConditionMinValue'
        produces 'application/json'

        response '200', 'Found' do
          run_test! 'return expected data' do
            expect(json).to eq(
              {
                'Imperial' => { 'Unit' => 'F', 'UnitType' => 18, 'Value' => 26 },
                'Metric' => { 'Unit' => 'C', 'UnitType' => 17, 'Value' => 12 }
              }
            )
          end
        end
      end
    end

    path '/api/v1/weather/historical/avg' do
      get 'returns current condition with avg value' do
        tags 'Current Conditions'
        operationId 'fetchConditionAvgValue'
        produces 'application/json'

        response '200', 'Found' do
          run_test! 'return expected data' do
            expect(json).to eq(
              {
                'Imperial' => { 'Unit' => 'F', 'UnitType' => 18, 'Value' => 37 },
                'Metric' => { 'Unit' => 'C', 'UnitType' => 17, 'Value' => 23 }
              }
            )
          end
        end
      end
    end
  end

  path '/api/v1/weather/by_time' do
    context 'when condition exist' do
      get 'returns current condition by epoch_time' do
        tags 'Current Conditions'
        operationId 'fetchConditionByTime'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :epoch_time, in: :query

        before do
          create :current_condition, epoch_time:, content: {
            'Temperature' => {
              'Metric' => { 'Value' => 10, 'Unit' => 'C', 'UnitType' => 17 },
              'Imperial' => { 'Value' => 50, 'Unit' => 'F', 'UnitType' => 18 }
            }
          }
        end

        response '200', 'Found' do
          let(:epoch_time) { 1_673_387_880 }

          run_test! 'return expected data' do
            expect(json['temperature']).to eq(
              {
                'Metric' => { 'Value' => 10, 'Unit' => 'C', 'UnitType' => 17 },
                'Imperial' => { 'Value' => 50, 'Unit' => 'F', 'UnitType' => 18 }
              }
            )
          end
        end
      end
    end

    context 'when condition not exist' do
      get 'returns current condition by epoch_time' do
        tags 'Current Conditions'
        operationId 'fetchConditionByTime'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :epoch_time, in: :query

        response '404', 'Not Found' do
          let(:epoch_time) { 1_673_387_777 }

          run_test!
        end
      end
    end
  end
end
