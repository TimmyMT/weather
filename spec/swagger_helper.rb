# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        schemas: {
          current_condition: {
            type: :object,
            properties: {
              local_observation_date_time: { type: :string, format: 'date-time' },
              temperature: {
                '$ref' => '#components/schemas/temperature'
              }
            }
          },
          temperature: {
            type: :object,
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
          }
        }
      }
    }
  }

  config.swagger_format = :yaml
end
