module CurrencyExchange
  class ProviderMap
    PROVIDERS = {
      currency_layer: Providers::CurrencyLayer
    }.freeze

    DEFAULT_PROVIDER = :currency_layer

    def initialize(config = Configuration.instance, providers = PROVIDERS)
      @config = config
      @providers = providers
    end

    def provider(name)
      provider_class = providers[name.to_sym]
      provider_class.new(access_key(name))
    end

    private

    attr_reader :name, :config, :providers

    def access_key(provider_name)
      config[:"#{provider_name}_access_key"]
    end
  end
end
