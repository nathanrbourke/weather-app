module View
  class ForecastWeatherDay < WeatherDay
    def initialize(data)
      super(data.merge('date' => data.fetch('valid_date')))
      @high_temp = data.fetch('high_temp')
      @low_temp = data.fetch('low_temp')
    end

    def tempurature
      high_temp
    end

    def secondary_tempurature
      low_temp
    end

    private

    attr_reader :high_temp, :low_temp
  end
end
