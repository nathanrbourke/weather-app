module Service
  class DailyForecast
    CACHE_BASE_SETTINGS = {
      domain_key_fragment: 'weather_report',
      collection_key_fragment: 'daily_forecast',
      expiry: 30 * 60 # minutes * seconds
    }.freeze
    NUM_OF_FORECAST_DAYS = 8

    def initialize(locale_information)
      cache_settings = CACHE_BASE_SETTINGS.merge(record_key_fragment: locale_information.fetch(:postal_code))
      @api_endpoint_cache = ::Service::ApiEndpointCache.new(
        endpoint: ::Api::Weatherbit.instance.endpoint(
          'GET', '/forecast/daily', locale_information.merge(country: 'US')
        ),
        cache: Cache.new(**cache_settings)
      )
    end

    def daily_forecast
      data
        .fetch('data')[0..(NUM_OF_FORECAST_DAYS - 1)]
        .map { |forecast| ::View::ForecastWeatherDay.new(forecast) }
    end

    def data_source
      data # access data method to fetch it before checking source.
      api_endpoint_cache.source
    end

    private

    attr_reader :weather_data, :api_endpoint_cache

    def data
      @data ||= api_endpoint_cache.fetch
    end
  end
end
