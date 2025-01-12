module Service
  class ApiEndpointCache
    include ApplicationHelper

    attr_reader :data_source, :service_up, :data

    def initialize(endpoint:, cache:)
      @endpoint = endpoint
      @cache = cache
      # Assume services are up until they are interacted with
      # When cache is unavailable, the API is NOT used as a backup
      # to avoid the risk of flooding it with requests.
      @service_up = true
    end

    def fetch
      cached_data = cache.get

      if cached_data
        self.data_source = 'cache'

        @data ||= cached_data
      else
        api_response = endpoint.call
        # TODO: This is an issue if future API responses use the "updated_at" attribute
        api_response.merge!(updated_at: Time.now.utc.iso8601)
        cache.set(api_response)
        self.data_source = 'api'

        @data ||= api_response
      end
    rescue Redis::CannotConnectError, Redis::TimeoutError, Api::Weatherbit::ApiError => e
      log_debug(e)
      @service_up = false
      nil
    end

    private

    attr_reader :endpoint, :cache
    attr_writer :data_source
  end
end
