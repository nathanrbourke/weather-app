class WeatherDay
  attr_reader :date, :secondary_tempurature, :humidity_percentage, :wind_dir, :wind_speed, :dew_point, :description

  def initialize(data)
    @date = Date.parse(data["ob_time"] || data["valid_date"])
    @snow = data.fetch("snow")
    @dew_point = data.fetch("dewpt")
    @wind_speed = data.fetch("wind_spd")
    @wind_dir = data.fetch("wind_dir")
    @humidity_percentage = data.fetch("rh")
    @description = data.fetch("weather").fetch("description")
  end

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

  # The descriptions from the API are unsatisfying, so this is an attempt to correct some,
  # but this could get more sophisticated by looking at current precipitation, cloud cover data
  # to determine the defining weather feature of the day.
  def forecast_description
    case description
    when "Broken clouds" then "Mostly cloudy"
    when "Few clouds", "Scattered clouds" then "Mostly sunny"
    else description
    end
  end
end