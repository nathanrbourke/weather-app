class ForecastsController < ApplicationController
  def index
  end

  def create
    weather_reporting = WeatherReporting.new({ postal_code: params[:postal_code] })
    @forecast = weather_reporting.daily_forecast
    @current_weather = weather_reporting.current_weather
    puts @forecast
    puts @current_weather
    render :index
  end
end
