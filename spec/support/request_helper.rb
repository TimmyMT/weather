# frozen_string_literal: true

require 'rails_helper'

# RequestHelper
#
module RequestHelper
  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
