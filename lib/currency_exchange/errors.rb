module CurrencyExchange
  module Errors
    class ProviderError < StandardError
      def initialize(provider)
        @provider = provider
      end

      private

      attr_reader :provider
    end

    class UnexpectedProviderError < ProviderError
      def message
        "Unexpected error request for provider #{provider}"
      end
    end

    class WrongProviderAccessKey < ProviderError
      def initialize(provider, access_key)
        super provider
        @access_key = access_key
      end

      def message
        "Wrong access key `#{access_key}` for provider `#{provider}`"
      end

      private

      attr_reader :access_key
    end
  end
end
