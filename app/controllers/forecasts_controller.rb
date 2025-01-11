class ForecastsController < ApplicationController
  def new
  end

  def create
    redirect_to forecast_path(params[:postal_code])
  end

  def show
    daily_forecast_service = ::Service::DailyForecast.new({ postal_code: params[:postal_code] })
    current_weather_service = ::Service::CurrentWeather.new({ postal_code: params[:postal_code] })

    @daily_forecast = daily_forecast_service.daily_forecast
    @current_weather = current_weather_service.current_weather

    @locale = current_weather_service.locale

    @current_weather_data_source = current_weather_service.data_source
    @daily_forecast_data_source = daily_forecast_service.data_source
  end
end
