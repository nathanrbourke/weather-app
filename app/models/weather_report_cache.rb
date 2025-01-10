class WeatherReportCache
  def initialize(collection_key_fragment, expiration)
    @collection_key_fragment = collection_key_fragment
    @expiration = expiration
  end

  def set(record_key_fragment, payload)
    REDIS.setex(key(record_key_fragment), expiration, payload.to_json)
  end

  def get(record_key_fragment)
    return unless (cache_result = REDIS.get(key(record_key_fragment)))


    JSON.parse(cache_result)
  end

  private

  DOMAIN_KEY_FRAGMENT = 'weather_report'.freeze
  attr_reader :collection_key_fragment, :expiration

  def key(record_key_fragment)
    "#{DOMAIN_KEY_FRAGMENT}:#{collection_key_fragment}:#{record_key_fragment}"
  end
end
