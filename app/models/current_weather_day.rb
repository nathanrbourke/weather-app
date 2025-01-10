class CurrentWeatherDay < WeatherDay
  def initialize(data)
    @date =     @date = Date.parse(data.fetch("ob_time"))
    @current_tempurature = data.fetch("temp")
    @dew_point = data.fetch("dewpt")
    @wind_speed = data.fetch("wind_spd")
    @wind_dir = data.fetch("wind_dir")
    @humidity_percentage = data.fetch("rh")
  end

  def tempurature
    @current_tempurature
  end

  def wind_direction
    found = Constants::COMPASS_DIRECTIONS.find { |range, _| range.include?(wind_dir.round) }

    raise "Wind direction not found." unless found

    found.last
  end
end