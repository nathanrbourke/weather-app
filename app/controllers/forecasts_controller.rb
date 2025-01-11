class ForecastsController < ApplicationController
  def new
  end

  def create
    redirect_to forecast_path(params[:postal_code])
  end

  def show
    @daily_forecast_service = ::Service::DailyForecast.new({ postal_code: params[:postal_code] })
    @current_weather_service = ::Service::CurrentWeather.new({ postal_code: params[:postal_code] })
  end
end
