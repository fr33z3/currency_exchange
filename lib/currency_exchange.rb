require "currency_exchange/version"

module CurrencyExchange
  autoload :CurrencyApi, 'currency_exchange/currency_api'
  autoload :Providers, 'currency_exchange/providers'
  autoload :Errors, 'currency_exchange/errors'
end
