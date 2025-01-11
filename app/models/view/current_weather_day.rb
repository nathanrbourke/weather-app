module View
  class CurrentWeatherDay < WeatherDay
    def initialize(data)
      super(data)
      @current_tempurature = data.fetch('temp')
    end

    def tempurature
      current_tempurature
    end

    private

    attr_reader :current_tempurature
  end
end
