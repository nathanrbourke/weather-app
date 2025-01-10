require 'singleton'
module Api
  class Weatherbit
    class InvalidParametersError < StandardError;end
    include Singleton
    include HTTParty

    base_uri 'https://api.weatherbit.io/v2.0'

    def endpoint(method, route, params)
      # Dynamically define an endpoint handler for the given method and route.
      Endpoint.new(self, method, route, params)
    end


    def get(route, query)
      response = self.class.get(route, query: query.merge(base_query))
      if response["error"] == "Invalid Parameters supplied."
        raise InvalidParametersError, "Invalid Parameters supplied to weatherbit API call"
      end
      response
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
        response = @api.class.send(@method.downcase, @route, query: @params.merge(@api.base_query))

        if response["error"] == "Invalid Parameters supplied."
          raise ::Api::Weatherbit::InvalidParametersError, "Invalid Parameters supplied to weatherbit API call"
        end

        response
      end
    end
  end

end
