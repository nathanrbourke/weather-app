require 'rails_helper'

RSpec.describe Cache do
  let(:redis_double) { instance_double('Redis') }
  let(:domain_key_fragment) { 'domain' }
  let(:collection_key_fragment) { 'collection' }
  let(:record_key_fragment) { 'record' }
  let(:expiry) { 3600 }
  let(:payload) { { foo: 'bar' }.to_json }

  subject do
    described_class.new(
      domain_key_fragment: domain_key_fragment,
      collection_key_fragment: collection_key_fragment,
      record_key_fragment: record_key_fragment,
      expiry: expiry
    )
  end

  before do
    stub_const('REDIS', redis_double)
  end

  describe '#set' do
    it 'stores the payload in Redis with the correct key and expiry' do
      expect(redis_double).to receive(:setex).with(
        "#{domain_key_fragment}:#{collection_key_fragment}:#{record_key_fragment}",
        expiry,
        payload
      )

      subject.set(payload)
    end
  end

  describe '#get' do
    context 'when the key exists in Redis' do
      it 'retrieves and parses the cached JSON payload' do
        allow(redis_double).to receive(:get).with(
          "#{domain_key_fragment}:#{collection_key_fragment}:#{record_key_fragment}"
        ).and_return(payload)

        expect(subject.get).to eq(JSON.parse(payload))
      end
    end

    context 'when the key does not exist in Redis' do
      it 'returns nil' do
        allow(redis_double).to receive(:get).and_return(nil)

        expect(subject.get).to be_nil
      end
    end
  end
end
