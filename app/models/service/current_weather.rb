module Service
  class CurrentWeather
    CACHE_BASE_SETTINGS = {
      domain_key_fragment: 'weather_report',
      collection_key_fragment: 'current_weather',
      expiry: 30 * 60 # minutes * seconds
    }.freeze

    delegate :service_up, to: :api_endpoint_cache
    delegate :data_source, to: :api_endpoint_cache

    def initialize(locale_information)
      @postal_code = locale_information.fetch(:postal_code)
      cache_settings = CACHE_BASE_SETTINGS.merge(record_key_fragment: @postal_code)
      @api_endpoint_cache = ::Service::ApiEndpointCache.new(
        endpoint: ::Api::Weatherbit.instance.endpoint('GET', '/current', locale_information.merge(country: 'US')),
        cache: Cache.new(**cache_settings)
      )
      @api_endpoint_cache.fetch
    end

    def current_weather
      ::View::CurrentWeatherDay.new(api_endpoint_cache.data.fetch('data').first)
    end

    def locale
      weather_record = api_endpoint_cache.data.fetch('data').first
      ::View::Locale.new(
        city_name: weather_record.fetch('city_name'),
        state_code: weather_record.fetch('state_code'),
        postal_code: postal_code
      )
    end

    private

    attr_reader :api_endpoint_cache, :postal_code
  end
end
