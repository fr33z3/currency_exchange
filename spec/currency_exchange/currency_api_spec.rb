require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CurrencyExchange::CurrencyApi do
  let(:provider) { spy('CurrencyProvider') }
  let(:api) { described_class.new(provider) }
  let(:supported_currencies) { %w[EUR USD AED] }
  let(:rates) { { 'EUR' => 0.9, 'AED' => 1.3 } }
  let(:date_rates) { { 'EUR' => 0.8, 'AED' => 1.5 } }
  let(:date) { Time.new(2016, 1, 1) }
  let(:source) { 'USD' }
  let(:target) { %w[EUR AED] }

  before do
    allow(provider).to receive(:list).and_return supported_currencies
    allow(provider).to receive(:live).with(source: source, target: target).and_return rates
    allow(provider).to receive(:historical).with(
      source: source, target: target, date: date
    ).and_return date_rates
  end

  describe '#supported_currencies' do
    subject { api.supported_currencies }

    it 'returns all supported rates' do
      is_expected.to equal supported_currencies
    end

    it 'calls #list method of provider' do
      subject
      expect(provider).to have_receive(:list)
    end
  end

  describe '#exchange_rates' do
    describe 'when date is not specified' do
      subject { api.exchange_rates(source, target) }

      it 'calls #live method of provider' do
        subject
        expect(provider).to have_received(:live).with(source: source, target: target)
      end
    end

    describe 'when date is specified' do
      subject { api.exchange_rates(source, target, date) }

      it 'calls #historical method of provider' do
        subject
        expect(provider).to have_received(:historical).with(
          source: source, target: target, date: date
        )
      end
    end
  end

  describe '#convert' do
    let(:value) { 12 }
    let(:live_result) { { 'EUR' => rates['EUR'] * value, 'AED' => rates['AED'] * value } }
    let(:date_result) do
      { 'EUR' => date_rates['EUR'] * value, 'AED' => date_rates['AED'] * value }
    end

    describe 'when date is not specified' do
      subject { api.convert(value, source, target) }

      it 'returns converted values for live' do
        is_expected.to match live_result
      end
    end

    describe 'when date is specified' do
      subject { api.convert(value, source, target, date) }

      it 'returns converted values for date' do
        is_expected.to match date_result
      end
    end
  end

  describe '#highest_rates' do
    subject { api.highest_rates(source, target) }
    let(:rates_range) { [rates, *[date_rates] * 6] }
    let(:highest_rates) do
      {
        'EUR' => {
          'value' => [rates['EUR'], date_rates['EUR']].max,
          'date' => Time.now
        },
        'AED' => {
          'value' => [rates['AED'], date_rates['AED']].max,
          'date' => Time.now - 24 * 60 * 60
        }
      }
    end

    before do
      allow(provider).to receive(:historical).and_return(*rates_range)
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    it 'returns highest rates for last seven days' do
      is_expected.to match highest_rates
    end
  end
end
# rubocop:enable Metrics/BlockLength
