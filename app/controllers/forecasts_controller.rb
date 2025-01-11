class ForecastsController < ApplicationController
  def new
  end

  def create
    redirect_to forecast_path(params[:postal_code])
  end

  def show
    daily_forecast_service = ::Service::DailyForecast.new({ postal_code: '06074' })
    current_weather_service = ::Service::CurrentWeather.new({ postal_code: '06074' })

    @daily_forecast = daily_forecast_service.daily_forecast
    @current_weather = current_weather_service.current_weather
  end
end
