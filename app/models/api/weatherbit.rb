require 'singleton'
module Api
  class Weatherbit
    class InvalidParametersError < StandardError; end
    include Singleton
    include HTTParty

    base_uri 'https://api.weatherbit.io/v2.0'

    def endpoint(method, route, params)
      Endpoint.new(self, method, route, params)
    end

    def base_query
      { key: ENV['WEATHERBIT_API_KEY'] }
    end

    class Endpoint
      def initialize(api, method, route, params)
        @api = api
        @method = method
        @route = route
        @params = params
      end

      def call
        all_params = @params.merge(@api.base_query)
        # TODO: Do not rely on send in the long term - create a better interface
        response = @api.class.send(@method.downcase, @route, query: all_params)

        if response['error'] == 'Invalid Parameters supplied.'
          raise ::Api::Weatherbit::InvalidParametersError,
                "Invalid params supplied to weatherbit API call. params: #{all_params}"
        end

        response
      end
    end
  end
end
