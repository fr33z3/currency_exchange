module CurrencyExchange
  module Providers
    module Helpers
      private

      def standartize_quotes(quotes)
        quotes.each_with_object({}) do |(symbol, rate), res|
          standard_symbol = symbol[3..-1]
          res[standard_symbol] = rate
        end
      end
    end
  end
end
