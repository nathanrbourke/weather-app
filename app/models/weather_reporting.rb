class WeatherReporting
  CACHE_EXPIRATION = 30 * 60 # minutes * seconds
  CACHE_PREFIX = 'weather_report:us'.freeze

  def initialize(locale_information)
    @locale_information = locale_information.merge(country: 'US')
    @cache_key = "#{CACHE_PREFIX}:#{@locale_information.fetch(:postal_code)}"
  end

  def daily_forecast
    fetch_weather_report unless report_is_cached?

    cached_report["daily_forecast"]["data"].map { |forecast| ForecastWeatherDay.new(forecast) }
  end

  def current_weather
    fetch_weather_report unless report_is_cached?
puts cached_report["current_weather"]
    weather = cached_report["current_weather"]["data"].first
    CurrentWeatherDay.new(weather)
  end

  private

  def fetch_weather_report
    weatherbit = WeatherbitApi.instance
    daily_forecast_api_response = weatherbit.get('/forecast/daily', @locale_information)
    current_weather_api_response = weatherbit.get('/current', @locale_information)

    cache_payload = {
      daily_forecast: daily_forecast_api_response,
      current_weather: current_weather_api_response
    }



    REDIS.setex(@cache_key, CACHE_EXPIRATION, cache_payload.to_json)
  end

  def report_is_cached?
    !!cached_report
  end

  def cached_report
    return @cached_report if @cached_report
    return unless (cache_result = REDIS.get(@cache_key))

    @cached_report = JSON.parse(cache_result, symbolize_keys: true)
  end
end
