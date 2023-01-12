require 'swagger_helper'

describe 'current conditions API' do
  path '/api/v1/weather/current' do
    get 'returns current condition' do
      tags 'Current Conditions'
      operationId 'fetchCurrentCondition'
      produces 'application/json'

      response '200', "Found" do
        schema type: :object,
        properties: {
          "Metric" => {
            type: :object,
            properties: {
              "Value" => { type: 'number' },
              "Unit" => { type: 'string' },
              "UnitType" => { type: 'integer' }
            }
          },
          "Imperial" => {
            type: :object,
            properties: {
              "Value" => { type: 'number' },
              "Unit" => { type: 'string' },
              "UnitType" => { type: 'integer' }
            }
          }
        }

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical' do
    get 'retrun conditions by last 24 hours' do
      tags 'Current Conditions'
      operationId 'fetchDayConditions'
      produces 'application/json'

      response '200', "Found" do
        schema type: :array, items: {
          '$ref' => '#/components/schemas/current_condition'
        }

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical/max' do
    get 'returns current condition with max value' do
      tags 'Current Conditions'
      operationId 'fetchConditionMaxValue'
      produces 'application/json'

      response '200', "Found" do
        schema type: :object, '$ref' => '#components/schemas/temperature'

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical/min' do
    get 'returns current condition with min value' do
      tags 'Current Conditions'
      operationId 'fetchConditionMinValue'
      produces 'application/json'

      response '200', "Found" do
        schema type: :object, '$ref' => '#components/schemas/temperature'

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical/avg' do
    get 'returns current condition with avg value' do
      tags 'Current Conditions'
      operationId 'fetchConditionAvgValue'
      produces 'application/json'

      response '200', "Found" do
        schema type: :object, '$ref' => '#components/schemas/temperature'

        run_test!
      end
    end
  end

  path '/api/v1/weather/by_time' do
    get 'returns current condition by epoch_time' do
      tags 'Current Conditions'
      operationId 'fetchConditionByTime'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :epoch_time, in: :query

      response '200', "Found" do
        schema type: :object, '$ref' => '#components/schemas/current_condition'

        run_test!
      end

      response '404', 'No content' do
        example 'application/json', :example_1, {
          error: "Conditions not found"
        }

        run_test!
      end
    end
  end
end
