require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CurrencyExchange::CLI do
  let(:api) { spy('API') }
  let(:printers) { [spy('Printer1'), spy('Printer2')] }
  let(:cli) { described_class.new(api, printers) }

  describe '#list' do
    let(:data) { double('ListData') }

    before do
      allow(api).to receive(:list).and_return data
      cli.list
    end

    it 'requests data' do
      expect(api).to have_received(:list)
    end

    it 'prints data' do
      printers.each do |printer|
        expect(printer).to have_received(:print_list).with(data)
      end
    end
  end

  describe '#convert' do
    let(:value) { 1 }
    let(:data) { double('ConverData') }

    before do
      allow(api).to receive(:convert).and_return data
      cli.convert(value)
    end

    it 'requests data' do
      expect(api).to have_received(:convert).with(value, 'USD', [], nil)
    end

    it 'prints data' do
      printers.each do |printer|
        expect(printer).to have_received(:print_converted).with('USD', data)
      end
    end
  end

  describe '#highest_rates' do
    let(:data) { double('HighestRatesData') }

    before do
      allow(api).to receive(:highest_rates).and_return data
      cli.highest_rates
    end

    it 'requests data' do
      expect(api).to have_received(:highest_rates).with('USD', [])
    end

    it 'prints data' do
      printers.each do |printer|
        expect(printer).to have_received(:print_highest_rates).with('USD', data)
      end
    end
  end

  describe '#exchange_rates' do
    let(:data) { double('ExchangeRates') }

    before do
      allow(api).to receive(:exchange_rates).and_return data
      cli.exchange_rates
    end

    it 'requests data' do
      expect(api).to have_received(:exchange_rates).with('USD', [], nil)
    end

    it 'prints data' do
      printers.each do |printer|
        expect(printer).to have_received(:print_exchange_rates).with('USD', nil, data)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
