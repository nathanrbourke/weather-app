class ForecastsController < ApplicationController
  def index
    if params[:postal_code]
      weather_report = WeatherReportService.new({ postal_code: params[:postal_code] })
      @daily_forecast = weather_report.daily_forecast.map { |forecast| ForecastWeatherDay.new(forecast) }
      @current_weather = CurrentWeatherDay.new(weather_report.current_weather)
    end
  end
end
