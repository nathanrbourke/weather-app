require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::Weatherbit do
  let(:weatherbit) { Api::Weatherbit.instance }
  let(:valid_route) { '/forecast' }
  let(:valid_query) { { postal_code: '02139' } }
  let(:valid_response) { { 'data' => ['forecast data'] } }
  let(:error_response) { { 'error' => 'Invalid API key' } }
  let(:url) { "https://api.weatherbit.io/v2.0#{valid_route}" }

  it 'returns the correct response when the API call is successful' do
    stub_request(:get, url)
      .with(query: valid_query.merge(key: ENV['WEATHERBIT_API_KEY']))
      .to_return(status: 200, body: valid_response.to_json, headers: {})

    response = weatherbit.get(valid_route, query: valid_query)

    expect(JSON.parse(response.body)).to eq(valid_response)
    expect(WebMock).to have_requested(:get, url)
      .with(query: valid_query.merge(key: ENV['WEATHERBIT_API_KEY'])).once
  end

  it 'raises an ApiError when the response contains an error' do
    ENV['WEATHERBIT_API_KEY'] = ''
    stub_request(:get, url)
      .with(query: valid_query.merge(key: ENV['WEATHERBIT_API_KEY']))
      .to_return(status: 200, body: error_response.to_json, headers: {})
    # weatherbit.get(valid_route, query: valid_query)
    expect { weatherbit.get(valid_route, query: valid_query) }
      .to raise_error(Api::Weatherbit::ApiError, 'Invalid API key')
  end

  it 'retries up to max_retries if a timeout occurs' do
    stub_request(:get, url)
      .with(query: valid_query.merge(key: ENV['WEATHERBIT_API_KEY']))
      .to_timeout

    expect { weatherbit.get(valid_route, query: valid_query) }
      .to raise_error(Api::Weatherbit::ApiError, 'Max retries 3 reached.')
  end
end
