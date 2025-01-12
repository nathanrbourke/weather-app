require 'singleton'
module Api
  class Weatherbit
    class ApiError < StandardError; end
    include Singleton
    include HTTParty
    include ApplicationHelper

    base_uri 'https://api.weatherbit.io/v2.0'
    default_timeout 5

    def endpoint(method, route, params)
      Endpoint.new(self, method, route, params)
    end

    def get(route, query:)
      query_with_key = query.merge(key)
      with_retries(3) do
        response = self.class.get(route, query: query_with_key)
        raise ApiError, '204 No content in body' if response.body.nil?

        json = JSON.parse(response.body)
        raise ApiError, json['error'] if json['error']

        response
      end
    rescue SocketError => e
      log_debug(e)
      raise ApiError, "Couldn't connect to the API"
    end

    def with_retries(max_retries)
      attempts = 0

      begin
        attempts += 1
        yield
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        log_debug(e)
        retry if attempts < max_retries
        raise ApiError, "Max retries #{max_retries} reached."
      end
    end

    def key
      { key: ENV['WEATHERBIT_API_KEY'] }
    end
  end
end
