require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CurrencyExchange::Providers::CurrencyLayer do
  let(:access_key) { CURRENCY_LAYER_ACCESS_KEY }
  let(:provider) { described_class.new(access_key) }
  include CurrencyExchange::Providers::Helpers

  describe '#list' do
    subject { provider.list }

    let(:supported_currencies) do
      api_resource(:currency_layer, 'list')['currencies'].keys
    end

    it 'is requesting the right endpoint' do
      subject
      expect(WebMock).to have_requested(
        :get,
        "http://apilayer.net/api/list?access_key=#{access_key}"
      )
    end

    it 'respond all supported currencies' do
      is_expected.to match_array supported_currencies
    end

    describe 'when the access key is wrong' do
      let(:access_key) { 'wrongaccesskey' }

      it 'raises exception' do
        expect { subject }.to raise_error(CurrencyExchange::Errors::WrongProviderAccessKey)
      end
    end
  end

  describe '#live' do
    let(:quotes) do
      quotes = api_resource(:currency_layer, 'live_without_target')['quotes']
      standartize_quotes(quotes)
    end

    subject { provider.live }

    it 'returns all quotes' do
      is_expected.to match quotes
    end

    it 'is requesting the right endpoint' do
      subject
      expect(WebMock).to have_requested(
        :get,
        "http://apilayer.net/api/live?access_key=#{access_key}&currencies=&source=USD"
      )
    end

    describe 'when the target is specified' do
      let(:target) { %w[EUR AED] }
      let(:quotes) do
        quotes = api_resource(:currency_layer, 'live_with_target')['quotes']
        standartize_quotes(quotes)
      end

      subject { provider.live(target: target) }

      it 'returns quotes for specified currencies' do
        is_expected.to match quotes
      end

      it 'is requesting the right endpoint' do
        subject
        expect(WebMock).to have_requested(
          :get,
          "http://apilayer.net/api/live?access_key=#{access_key}&currencies=EUR,AED&source=USD"
        )
      end
    end

    describe 'when the access key is wrong' do
      let(:access_key) { 'wrongaccesskey' }

      it 'raises exception' do
        expect { subject }.to raise_error(CurrencyExchange::Errors::WrongProviderAccessKey)
      end
    end
  end

  describe '#historical' do
    describe 'when the date is not specified' do
      subject { provider.historical }

      it 'is rising exception' do
        expect { subject }.to raise_error(CurrencyExchange::Errors::UnexpectedProviderError)
      end
    end

    describe 'when the date is specified' do
      let(:date) { Time.new(2016, 1, 2) }
      subject { provider.historical(date: date) }

      let(:quotes) do
        quotes = api_resource(:currency_layer, 'historical_with_date')['quotes']
        standartize_quotes(quotes)
      end

      it 'returns quotes for specified date' do
        is_expected.to match quotes
      end
    end

    describe 'when the target is specified' do
      let(:target) { %w[EUR AED] }
      let(:date) { Time.new(2016, 1, 2) }
      subject { provider.historical(date: date, target: target) }

      let(:quotes) do
        quotes = api_resource(:currency_layer, 'historical_with_date_n_target')['quotes']
        standartize_quotes(quotes)
      end

      it 'returns quotes for specified date and currencies' do
        is_expected.to match quotes
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
