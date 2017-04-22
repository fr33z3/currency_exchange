require 'json'

CURRENCY_LAYER_ACCESS_KEY = 'currencylayeraccesskey'.freeze

def api_resource(provider, name)
  path = File.expand_path("../responses/#{provider}/#{name}.json", __FILE__)
  JSON.parse(File.read(path))
end

# rubocop:disable all
def stub_currency_layer_requests!
  # list stubs
  WebMock.stub_request(:get, 'apilayer.net/api/list')
         .with(query: WebMock.hash_including(:access_key))
         .to_return(body: api_resource(:currency_layer, 'wrong_access_key').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/list')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY))
         .to_return(body: api_resource(:currency_layer, 'list').to_json, status: 200)

  # live stubs
  WebMock.stub_request(:get, 'apilayer.net/api/live')
         .with(query: WebMock.hash_including(:access_key))
         .to_return(body: api_resource(:currency_layer, 'wrong_access_key').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/live')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY))
         .to_return(body: api_resource(:currency_layer, 'live_without_target').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/live')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY, source: 'USD', currencies: 'EUR,AED'))
         .to_return(body: api_resource(:currency_layer, 'live_with_target').to_json, status: 200)

  # historical stubs
  WebMock.stub_request(:get, 'apilayer.net/api/historical')
         .with(query: WebMock.hash_including(:access_key))
         .to_return(body: api_resource(:currency_layer, 'wrong_access_key').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/historical')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY))
         .to_return(body: api_resource(:currency_layer, 'historical_without_date').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/historical')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY, source: 'USD', date: '2016-01-02'))
         .to_return(body: api_resource(:currency_layer, 'historical_with_date').to_json, status: 200)

  WebMock.stub_request(:get, 'apilayer.net/api/historical')
         .with(query: WebMock.hash_including(access_key: CURRENCY_LAYER_ACCESS_KEY, source: 'USD', date: '2016-01-02', currencies: 'EUR,AED'))
         .to_return(body: api_resource(:currency_layer, 'historical_with_date_n_target').to_json, status: 200)
end
# rubocop:enable all
