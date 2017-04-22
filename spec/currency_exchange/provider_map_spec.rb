require 'spec_helper'

RSpec.describe CurrencyExchange::ProviderMap do
  let(:config) { { some_provider_access_key: 'access_key' } }
  let(:provider) { spy('Provider') }
  let(:providers) { { some_provider: provider } }
  let(:map) { described_class.new(config, providers) }

  describe '#provider' do
    subject { map.provider(:some_provider) }

    it 'returns provider' do
      subject
      expect(provider).to have_received(:new).with('access_key')
    end
  end
end
