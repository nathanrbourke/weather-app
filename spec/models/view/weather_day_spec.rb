require 'rails_helper'

RSpec.describe View::WeatherDay do
  let(:base_data) { weather_day_data_fixture }

  subject { described_class.new(base_data) }

  describe '#initialize' do
    it 'initializes with valid data' do
      expect(subject.dew_point).to eq(3.0)
      expect(subject.wind_speed).to eq(10)
      expect(subject.humidity_percentage).to eq(75)
    end

    it 'raises an error if data is missing required keys' do
      incomplete_data = base_data.except('date')
      expect { described_class.new(incomplete_data) }.to raise_error(KeyError)
    end
  end

  describe '#template_path' do
    it 'returns the correct template path' do
      expect(subject.template_path).to eq('forecasts/partials/weather_card')
    end
  end

  describe '#day_of_week' do
    it 'returns the correct day of the week' do
      expect(subject.day_of_week).to eq('Saturday')
    end

    it 'returns correct days for other days of the week' do
      expect(described_class.new(base_data.merge('date' => '2025-01-12')).day_of_week).to eq('Sunday')
      expect(described_class.new(base_data.merge('date' => '2025-01-13')).day_of_week).to eq('Monday')
      expect(described_class.new(base_data.merge('date' => '2025-01-14')).day_of_week).to eq('Tuesday')
      expect(described_class.new(base_data.merge('date' => '2025-01-15')).day_of_week).to eq('Wednesday')
    end

    it 'raises AttributeNotFoundError for out-of-range days' do
      allow(Constants::DAYS).to receive(:fetch).and_raise(View::WeatherDay::AttributeNotFoundError, 'day_of_week')

      expect { subject.day_of_week }.to raise_error(View::WeatherDay::AttributeNotFoundError, 'day_of_week')
    end
  end

  describe '#month_and_day' do
    it 'returns the correct month and day for a given date' do
      expect(subject.month_and_day).to eq('Jan 11')
    end

    it 'returns correct month and day for other dates' do
      expect(described_class.new(base_data.merge('date' => '2025-02-14')).month_and_day).to eq('Feb 14')
      expect(described_class.new(base_data.merge('date' => '2025-03-01')).month_and_day).to eq('Mar 1')
      expect(described_class.new(base_data.merge('date' => '2025-07-04')).month_and_day).to eq('Jul 4')
      expect(described_class.new(base_data.merge('date' => '2025-12-25')).month_and_day).to eq('Dec 25')
      expect(described_class.new(base_data.merge('date' => '2025-10-31')).month_and_day).to eq('Oct 31')
    end

    it 'raises AttributeNotFoundError for out-of-range days' do
      allow(Constants::DAYS).to receive(:fetch).and_raise(View::WeatherDay::AttributeNotFoundError, 'day_of_week')

      expect { subject.day_of_week }.to raise_error(View::WeatherDay::AttributeNotFoundError, 'day_of_week')
    end
  end

  describe '#wind_direction' do
    it 'returns the correct wind direction' do
      expect(subject.wind_direction).to eq('W')
    end

    it 'returns correct wind directions for other values' do
      expect(described_class.new(base_data.merge('wind_dir' => 1)).wind_direction).to eq('N')
      expect(described_class.new(base_data.merge('wind_dir' => 90)).wind_direction).to eq('E')
      expect(described_class.new(base_data.merge('wind_dir' => 180)).wind_direction).to eq('S')
      expect(described_class.new(base_data.merge('wind_dir' => 315)).wind_direction).to eq('NW')
      expect(described_class.new(base_data.merge('wind_dir' => 360)).wind_direction).to eq('N')
    end

    it 'raises AttributeNotFoundError for out-of-range days' do
      expect do
        described_class.new(base_data.merge('wind_dir' => 400)).wind_direction
      end.to raise_error(
        View::WeatherDay::AttributeNotFoundError, 'wind_direction'
      )
    end
  end

  describe '#forecast_description' do
    it 'returns "Mostly cloudy" for "Broken clouds"' do
      expect(subject.forecast_description).to eq('Mostly cloudy')
    end

    it 'returns the same description for other weather types' do
      subject = described_class.new(base_data.merge('weather' => { 'description' => 'Clear sky' }))
      expect(subject.forecast_description).to eq('Clear sky')
    end
  end
end
