class ForecastsController < ApplicationController
  def index
    if params[:postal_code]
      daily_forecast_service = ::Service::DailyForecast.new({ postal_code: params[:postal_code] })
      current_weather_service = ::Service::CurrentWeather.new({ postal_code: params[:postal_code] })

      @daily_forecast = daily_forecast_service.daily_forecast
      @current_weather = current_weather_service.current_weather
    end
  end
end
