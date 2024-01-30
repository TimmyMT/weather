require 'swagger_helper'

describe 'Health API' do
  path '/api/v1/health' do
    get 'Fetch status server' do
      tags 'Health'
      produces 'application/json'

      response '200', 'Success' do
        run_test! do
          expect(JSON.parse(response.body)).to eq({"success" => "Server is running"})
        end
      end
    end
  end
end
