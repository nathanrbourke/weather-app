module View
  class WeatherDay
    attr_reader :tempurature, :secondary_tempurature, :humidity_percentage, :wind_speed, :dew_point

    class AttributeNotFoundError < StandardError; end

    def initialize(data)
      @date = Date.parse(data.fetch('date'))
      @dew_point = data.fetch('dewpt')
      @wind_speed = data.fetch('wind_spd')
      @wind_dir = data.fetch('wind_dir')
      @humidity_percentage = data.fetch('rh')
      @description = data.fetch('weather').fetch('description')
    end

    def template_path
      'forecasts/partials/weather_card'
    end

    def day_of_week
      Constants::DAYS.fetch(date.cwday - 1) { raise AttributeNotFoundError, 'day_of_week' }
    end

    def month_and_day
      month_name = Constants::MONTHS.fetch(date.month - 1) { |_| raise AttributeNotFoundError, 'month_nane' }

      "#{month_name[0..2]} #{date.day}"
    end

    def wind_direction
      direction = Constants::COMPASS_DIRECTIONS.find { |range, _| range.include?(wind_dir.round) }

      raise AttributeNotFoundError, 'wind_direction' if direction.nil?

      direction.last # access value in [key, value]
    end

    # The descriptions from the API are unsatisfying, so this is an attempt to correct some,
    # but this could get more sophisticated by looking at current precipitation, cloud cover data
    # to determine the defining weather feature of the day.
    def forecast_description
      case description
      when 'Broken clouds' then 'Mostly cloudy'
      when 'Few clouds', 'Scattered clouds' then 'Mostly sunny'
      else description
      end
    end

    private

    attr_reader :wind_dir, :date, :description
  end
end
