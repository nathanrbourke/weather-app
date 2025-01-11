module Service
  class DailyForecast
    CACHE_BASE_SETTINGS = {
      domain_key_fragment: 'weather_report',
      collection_key_fragment: 'daily_forecast',
      expiry: 30 * 60 # minutes * seconds
    }

    def initialize(locale_information)
      cache_settings = CACHE_BASE_SETTINGS.merge(record_key_fragment: locale_information.fetch(:postal_code))
      @api_endpoint_cache = ::Service::ApiEndpointCache.new(
        endpoint: ::Api::Weatherbit.instance.endpoint(
          'GET', '/forecast/daily', locale_information.merge(country: 'US')
        ),
        cache: Cache.new(**cache_settings)
      )
    end

    delegate :source, to: :api_endpoint_cache

    def daily_forecast
      @data ||= api_endpoint_cache.fetch
      @data['data'].map { |forecast| ::View::ForecastWeatherDay.new(forecast) }
    end

    private

    attr_reader :api_endpoint_cache
  end
end
