require 'singleton'

class WeatherbitApi
  include Singleton
  include HTTParty

  base_uri 'https://api.weatherbit.io/v2.0'

  def get(route, query)
    self.class.get(route, query: query.merge(base_query))
  end

  def base_query
    { key: ENV['WEATHERBIT_API_KEY'] }
  end
end
