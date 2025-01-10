module Service
  class ApiEndpointCache
    attr_reader :source
    def initialize(endpoint:, cache:)
      @endpoint = endpoint
      @cache = cache
    end

    def fetch
      cached_data = cache.get

      if cached_data
        self.source = 'cache'

        cached_data
      else
        api_response = endpoint.call
        # TODO: This is an issue if future API responses use the "updated_at" attribute
        api_response.merge!(updated_at: Time.now.utc.iso8601)
        cache.set(api_response)
        self.source = 'api'

        api_response
      end
    end

    private

    attr_reader :endpoint, :cache, :record_key
    attr_writer :source
  end
end
