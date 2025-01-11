module ViewSpecHelperMethods
  def weather_day_data_fixture
    {
      'date' => '2025-01-11',
      'dewpt' => 3.0,
      'wind_spd' => 10,
      'wind_dir' => 270,
      'rh' => 75,
      'weather' => { 'description' => 'Broken clouds' }
    }
  end
end
