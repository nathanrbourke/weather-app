class ForecastsController < ApplicationController
  def index
    if params[:postal_code]
      weather_reporting = WeatherReporting.new({ postal_code: params[:postal_code] })
      @daily_forecast = weather_reporting.daily_forecast
      @current_weather = weather_reporting.current_weather
      @last_cached_minutes_ago = 30
    end
  end
end
