require 'rails_helper'

module MockHelper
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
end

RSpec.configure do |config|
  config.include MockHelper
end
