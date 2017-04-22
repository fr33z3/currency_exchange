require 'forwardable'

module CurrencyExchange
  class CurrencyApi
    extend Forwardable

    def initialize(provider)
      @provider = provider
    end

    def_delegator :@provider, :list, :list

    def exchange_rates(source = 'USD', target = [], date = nil)
      if date && !today?(date)
        provider.historical(source: source, target: target, date: date)
      else
        provider.live(source: source, target: target)
      end
    end

    def convert(value, source = 'USD', target = [], date = nil)
      rates = exchange_rates(source, target, date)
      rates.each_with_object({}) do |(symbol, rate), res|
        res[symbol] = value * rate
      end
    end

    def highest_rates(source = 'USD', target = [])
      highest_hash = {}

      for_seven_days do |date|
        rates = exchange_rates(source, target, date)
        highest_hash = choose_highest(highest_hash, rates, date)
      end

      highest_hash
    end

    private

    attr_reader :provider

    def today?(date)
      date.strftime('%Y-%m-%d') == Time.now.strftime('%Y-%m-%d')
    end

    def choose_highest(prev_rates, new_rates, date)
      new_rates.each_with_object(prev_rates) do |(symbol, rate), res|
        stored = res[symbol] && res[symbol]['value']
        if !stored || rate > stored
          res[symbol] = { 'value' => rate, 'date' => date }
        end
      end
    end

    def for_seven_days
      day = 24 * 60 * 60
      (0..6).each do |day_num|
        date = Time.now - day_num * day
        yield date
      end
    end
  end
end
