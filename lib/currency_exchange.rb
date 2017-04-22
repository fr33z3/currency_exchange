require "currency_exchange/version"

module CurrencyExchange
  autoload :CurrencyApi, 'currency_exchange/currency_api'
  autoload :Providers, 'currency_exchange/providers'
  autoload :Errors, 'currency_exchange/errors'
  autoload :Configuration, 'currency_exchange/configuration'
  autoload :CLI, 'currency_exchange/cli'
  autoload :ProviderMap, 'currency_exchange/provider_map'
  autoload :Printers, 'currency_exchange/printers'
end
