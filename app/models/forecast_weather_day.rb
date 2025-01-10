class ForecastWeatherDay < WeatherDay

  attr_reader :date, :high_temp, :low_temp, :precipitation_propability, :snow
  def initialize(data)
    @date = Date.parse(data.fetch("valid_date"))
    @high_temp = data.fetch("high_temp")
    @low_temp = data.fetch("low_temp")
    @precipitation_propability = data.fetch("pop")
    @snow = data.fetch("snow")
    @dew_point = data.fetch("dewpt")
    @wind_speed = data.fetch("wind_spd")
    @wind_dir = data.fetch("wind_dir")
    @humidity_percentage = data.fetch("rh")
  end

  def tempurature
    high_temp
  end

  def secondary_tempurature
    low_temp
  end
end