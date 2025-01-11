module View
  class CurrentWeatherDay < WeatherDay
    attr_reader :city_name, :state_code

    def initialize(data)
      super(data)
      @current_tempurature = data.fetch('temp')
      @city_name = data.fetch('city_name')
      @state_code = data.fetch('state_code')
    end

    def tempurature
      current_tempurature
    end

    private

    attr_reader :current_tempurature
  end
end
