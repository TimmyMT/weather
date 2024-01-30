# frozen_string_literal: true

class CurrentConditionSerializer < ActiveModel::Serializer
  attributes :local_observation_date_time, :temperature

  def temperature
    object.content['Temperature']
  end
end
