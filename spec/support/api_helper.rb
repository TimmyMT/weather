# frozen_string_literal: true

require 'rails_helper'

# ApiHelper
#
module ApiHelper
  include Rack::Test::Methods

  def json
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
