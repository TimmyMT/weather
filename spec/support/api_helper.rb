# frozen_string_literal: true

require 'rails_helper'

# ApiHelper
#
module ApiHelper
  include Rack::Test::Methods

  def mock_request(context_url, body)
    api_url = "http://dataservice.accuweather.com"
    api_key = Rails.application.credentials.api_key
    builded_url = "#{api_url}/#{context_url}?apikey=#{api_key}"
    
    stub_request(:get, builded_url).
      with(
        headers: {
          'Accept'=>'*/*',
          'Host'=>'dataservice.accuweather.com'
        }
      ).
      to_return(
        status: 200,
        body: body
      )
  end

  def json
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
