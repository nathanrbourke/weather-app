class WeatherDay
  attr_reader :date, :secondary_tempurature, :humidity_percentage, :wind_dir, :wind_speed, :dew_point


  def day_of_week
    Constants::DAYS[date.cwday - 1]
  end

  def month_and_day
    "#{Constants::MONTHS[date.month - 1][0..2]} #{date.day}"
  end


  def wind_direction
    found = Constants::COMPASS_DIRECTIONS.find { |range, _| range.include?(wind_dir.round) }

    raise "Wind direction not found." unless found

    found.last
  end

  def forecast_description
    "Partly Cloudy"
  end
end