require 'twitter'

module CurrencyExchange
  module Printers
    class Twitter
      def initialize(config = Configuration.instance)
        @config = config
      end

      def print_list(list)
        puts 'Printing list to twitter'
        print_listted_posts(list.join(','))
      end

      def print_converted(source, source_value, conversions)
        puts 'Printing conversions to twitter'
        message = conversions.map do |currency, value|
          "#{source_value} #{source} = #{value} #{currency}"
        end.join(',')

        print_splitted_posts(message)
      end

      def print_highest_rates(source, rates)
        puts 'Printing highest rates to twitter'
        message = rates.map do |currency, rate|
          value = rate['value']
          date = rate['date'].strftime('%Y-%m-%d')
          "#{source} -> #{currency}: #{value} (#{date})"
        end.join(',')

        print_splitted_posts(message)
      end

      def print_exchange_rates(source, date, rates)
        puts 'Printing exhcange rates to twitter'
        date_str = (date || Time.now).strftime('%Y-%m-%d')
        message = "#{date_str} " + rates.map do |currency, value|
          "#{source} -> #{currency}: #{value}"
        end.join(',')

        print_splitted_posts(message)
      end

      private

      attr_reader :config

      def print_splitted_posts(message)
        splitted_posts(message).each do |post|
          client.update(post)
        end
      end

      def splitted_posts(message)
        message.split(',').each_with_object([nil]) do |part, messages|
          joined = [messages.last, part].compact.join(',')
          if joined.size <= 140
            messages[-1] = joined
          else
            messages << part
          end
        end
      end

      def client
        @_client ||= ::Twitter::REST::Client.new do |c|
          c.consumer_key = config[:twitter_consumer_key]
          c.consumer_secret = config[:twitter_consumer_secret]
          c.access_token = config[:twitter_access_token]
          c.access_token_secret = config[:twitter_access_token_secret]
        end
      end
    end
  end
end
