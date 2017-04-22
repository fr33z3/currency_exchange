require 'uri'
require 'net/http'
require 'json'

module CurrencyExchange
  module Providers
    class CurrencyLayer
      include Helpers

      def initialize(access_key)
        @access_key = access_key
      end

      def list
        request_uri = uri(:list)
        response = request(request_uri)
        response['currencies'].keys
      end

      def live(source: 'USD', target: [])
        request_uri = uri(
          :live,
          source: source,
          currencies: target.join(',')
        )
        response = request(request_uri)
        standartize_quotes(response['quotes'])
      end

      def historical(date: Time.now, source: 'USD', target: [])
        request_uri = uri(
          :historical,
          source: source,
          currencies: target.join(','),
          date: date.strftime('%Y-%m-%d')
        )
        response = request(request_uri)
        standartize_quotes(response['quotes'])
      end

      private

      attr_reader :access_key

      def request(uri)
        req = Net::HTTP::Get.new(uri)
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end
        handle_response! JSON.parse(res.body)
      end

      def uri(endpoint, params = {})
        params[:access_key] = access_key

        URI::HTTP.build(
          host: 'apilayer.net',
          path: "/api/#{endpoint}",
          query: URI.encode_www_form(params)
        )
      end

      def handle_response!(response)
        return response if response['success']

        case response['error']['code']
        when 101
          raise Errors::WrongProviderAccessKey.new('currency layer', access_key)
        else
          raise Errors::UnexpectedProviderError.new('currency layer', response['error']['info'])
        end
      end
    end
  end
end
