require 'rails_helper'

RSpec.describe View::ForecastWeatherDay do
  let(:base_data) do
    weather_day_data_fixture.except('date').merge(
      'valid_date' => '2025-01-11',
      'high_temp' => 6,
      'low_temp' => 3
    )
  end

  subject { described_class.new(base_data) }

  describe '#initialize' do
    it 'initializes with valid data' do
      expect(subject.dew_point).to eq(3.0)
      expect(subject.wind_speed).to eq(10)
      expect(subject.humidity_percentage).to eq(75)
    end

    it 'raises an error if data is missing required keys' do
      incomplete_data = base_data.except('valid_date')
      expect { described_class.new(incomplete_data) }.to raise_error(KeyError)
    end
  end

  describe '#tempurature' do
    it 'returns the correct high tempurature' do
      expect(subject.tempurature).to eq(6)
    end
  end

  describe '#' do
    it 'returns the correct low tempurature' do
      expect(subject.secondary_tempurature).to eq(3)
    end
  end
end
