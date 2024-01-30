# frozen_string_literal: true

module Calculations
  class TemperatureByDay
    attr_reader :setting

    def initialize(collection, setting)
      content = collection.pluck(:content)

      @setting = setting

      metric = content.pluck('Temperature').pluck('Metric')
      imperial = content.pluck('Temperature').pluck('Imperial')

      @metric_value = metric.pluck('Value')
      @m_unit_type = metric.first['UnitType']
      @m_unit = metric.first['Unit']

      @imperial_value = imperial.pluck('Value')
      @i_unit_type = imperial.first['UnitType']
      @i_unit = imperial.first['Unit']
    end

    def call
      {
        'Metric' => make_data(@metric_value, @m_unit_type, @m_unit),
        'Imperial' => make_data(@imperial_value, @i_unit_type, @i_unit)
      }
    end

    private

    def make_data(value, unit_type, unit)
      {
        'Value' => setting == 'avg' ? (value.sum / value.size).round(2) : (setting == 'min' ? value.min : value.max),
        'Unit' => unit,
        'UnitType' => unit_type
      }
    end
  end
end
