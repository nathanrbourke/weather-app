module View
  class Locale
    attr_reader :city_name, :state_code, :postal_code

    def initialize(city_name:, state_code:, postal_code:)
      @city_name = city_name
      @state_code = state_code
      @postal_code = postal_code
    end

    def template_path
      'forecasts/partials/locale'
    end
  end
end
