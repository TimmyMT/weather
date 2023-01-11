class Calculations::TemperatureByDay
  attr_reader :setting

  def initialize(collection, setting)
    content = collection.pluck(:content)

    @setting = setting

    @metric_value = content.pluck('Temperature').pluck('Metric').pluck('Value')
    @m_unit_type = content.pluck('Temperature').pluck('Metric').first['UnitType']
    @m_unit = content.pluck('Temperature').pluck('Metric').first['Unit']

    @imperial_value = content.pluck('Temperature').pluck('Imperial').pluck('Value')
    @i_unit_type = content.pluck('Temperature').pluck('Imperial').first['UnitType']
    @i_unit = content.pluck('Temperature').pluck('Imperial').first['Unit']
  end

  def call#(collection, setting)
    # result = collection.pluck(:content)

    # met_val = result.pluck('Temperature').pluck('Metric').pluck('Value')
    # imp_val = result.pluck('Temperature').pluck('Imperial').pluck('Value')

    # metric = {
    #   'Value' => setting == 'avg' ? (met_val.sum / met_val.size).round(2) : eval("#{met_val}.#{setting}"),
    #   'Unit' => 'C',
    #   'UnitType' => result.pluck('Temperature').pluck('Metric').first['UnitType']
    # }
    # imperial = {
    #   'Value' => setting == 'avg' ? (imp_val.sum / imp_val.size).round(2) : eval("#{imp_val}.#{setting}"),
    #   'Unit' => 'C',
    #   'UnitType' => result.pluck('Temperature').pluck('Imperial').first['UnitType']
    # }

    {
      'Metric' => make_data(@metric_value, @m_unit_type, @m_unit),
      'Imperial' => make_data(@imperial_value, @i_unit_type, @i_unit)
    }
  end

  private

  def make_data(value, unit_type, unit)
    {
      'Value' => setting == 'avg' ? (value.sum / value.size).round(2) : eval("#{value}.#{setting}"),
      'Unit' => unit,
      'UnitType' => unit_type
    }
  end
end
