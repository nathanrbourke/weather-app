module Service
  class CurrentWeather
    CACHE_BASE_SETTINGS = {
      domain_key_fragment: 'weather_report',
      collection_key_fragment: 'current_weather',
      expiry: 30 * 60 # minutes * seconds
    }.freeze

    def initialize(locale_information)
      cache_settings = CACHE_BASE_SETTINGS.merge(record_key_fragment: locale_information.fetch(:postal_code))
      @api_endpoint_cache = ::Service::ApiEndpointCache.new(
        endpoint: ::Api::Weatherbit.instance.endpoint('GET', '/current', locale_information.merge(country: 'US')),
        cache: Cache.new(**cache_settings)
      )
    end

    delegate :source, to: :api_endpoint_cache

    def current_weather
      @data ||= api_endpoint_cache.fetch

      ::View::CurrentWeatherDay.new(@data['data'].first)
    end

    private

    attr_reader :api_endpoint_cache
  end
end
