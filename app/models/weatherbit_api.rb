require 'singleton'

class WeatherbitApi
  class InvalidParametersError < StandardError;end
  include Singleton
  include HTTParty

  base_uri 'https://api.weatherbit.io/v2.0'

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
end
