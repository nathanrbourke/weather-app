module Service
  class DailyForecast
    CACHE_BASE_SETTINGS = {
      domain_key_fragment: 'weather_report',
      collection_key_fragment: 'daily_forecast',
      expiry: 30 * 60 # minutes * seconds
    }.freeze
    NUM_OF_FORECAST_DAYS = 8

    delegate :service_up, to: :api_endpoint_cache
    delegate :data_source, to: :api_endpoint_cache

    def initialize(locale_information)
      cache_settings = CACHE_BASE_SETTINGS.merge(record_key_fragment: locale_information.fetch(:postal_code))
      endpoint = ::Api::Weatherbit.instance.endpoint('GET', '/forecast/daily', locale_information.merge(country: 'US'))
      @api_endpoint_cache = ::Service::ApiEndpointCache.new(
        endpoint: endpoint,
        cache: Cache.new(**cache_settings)
      )
      @api_endpoint_cache.fetch
    end

    # Truncate the number forecast days to reasonable display length.
    def daily_forecast
      @api_endpoint_cache.data
                         .fetch('data')[0..(NUM_OF_FORECAST_DAYS - 1)]
                         .map { |forecast| ::View::ForecastWeatherDay.new(forecast) }
    end

    private

    attr_reader :api_endpoint_cache
  end
end
