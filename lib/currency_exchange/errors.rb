module CurrencyExchange
  module Errors
    class ProviderError < StandardError
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def to_s
        message
      end

      private

      attr_reader :message
    end

    class UnexpectedProviderError < ProviderError
      def initialize(provider, message)
        super "Unexpected error (#{provider}): #{message}"
      end
    end

    class WrongProviderAccessKey < ProviderError
      def initialize(provider, access_key)
        super "Wrong access key `#{access_key}` for provider `#{provider}`"
      end
    end
  end
end
