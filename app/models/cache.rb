class Cache
  def initialize(domain_key_fragment:, collection_key_fragment:, record_key_fragment:, expiry:)
    @domain_key_fragment = domain_key_fragment
    @collection_key_fragment = collection_key_fragment
    @record_key_fragment = record_key_fragment
    @expiry = expiry
  end

  def set(payload)
    REDIS.setex(key, expiry, payload)
  end

  def get
    cache_result = REDIS.get(key)
    return unless cache_result

    JSON.parse(cache_result)
  end

  private

  attr_reader :domain_key_fragment, :collection_key_fragment, :expiry, :record_key_fragment

  def key
    "#{domain_key_fragment}:#{collection_key_fragment}:#{record_key_fragment}"
  end
end
