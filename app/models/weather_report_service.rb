class WeatherReportService
  CACHE_EXPIRATION = 30 * 60 # minutes * seconds
  WEATHER_RESOURCES = {
    daily_forecast: { cache: WeatherReportCache.new('daily_forecast', CACHE_EXPIRATION), api_endpoint: '/forecast/daily' },
    current_weather: { cache: WeatherReportCache.new('current_weather', CACHE_EXPIRATION), api_endpoint: '/current' }
  }


  def initialize(locale_information)
    @locale_information = locale_information.merge(country: 'US')
    @record_key = locale_information.fetch(:postal_code)
  end

  def daily_forecast
    data_for_resource(:daily_forecast)['data']
  end 

  def current_weather
    data_for_resource(:current_weather)['data'].first
  end

  def data_for_resource(resource_name)
    cache = WEATHER_RESOURCES.dig(resource_name, :cache)
    cached_data = cache.get(@record_key)
    return cached_data if cached_data

    api_response = WeatherbitApi.instance.get(WEATHER_RESOURCES.dig(resource_name, :api_endpoint), @locale_information)
    api_response.merge!(updated_at: Time.now.utc.iso8601)

    cache.set(@record_key, api_response)

    api_response
  end



  # Take the most stale timestamp between the various
  # records of cached data to show worst case scenario to user.
  def updated_at
    times = CACHE_COLLECTIONS.map do |cache_collection|
      report = cache_collection.get(@record_key)
      Time.parse(report['updated_at'])
    end

    times.min
  end
end
