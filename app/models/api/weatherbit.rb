require 'singleton'
module Api
  class Weatherbit
    class ApiError < StandardError; end
    include Singleton
    include HTTParty

    base_uri 'https://api.weatherbit.io/v2.0'
    default_timeout 5

    def endpoint(method, route, params)
      Endpoint.new(self, method, route, params)
    end

    def get(route, query:)
      query_with_key = query.merge(key)
      with_retries(3) do
        response = self.class.get(route, query: query_with_key)
        json = JSON.parse(response)

        raise ApiError, json['error'] if json['error']

        response
      end
    end

    def with_retries(max_retries)
      attempts = 0

      begin
        attempts += 1
        yield
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        Rails.logger.debug("#{e.class.name}, Message: #{e.message}")
        retry if attempts < max_retries
        raise ApiError, "Max retries #{max_retries} reached."
      end
    end

    def key
      { key: ENV['WEATHERBIT_API_KEY'] }
    end
  end
end
