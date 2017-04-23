module CurrencyExchange
  module Printers
    class Console
      def print_list(list)
        puts "Supported Currencies\n"
        list.each do |currency|
          puts currency
        end
      end

      def print_converted(source, source_value, conversions)
        puts "Conversions for #{source_value} #{source}"
        conversions.each do |currency, value|
          puts "  #{currency} #{value}"
        end
      end

      def print_highest_rates(source, rates)
        puts "Highest rates for #{source}"
        rates.each do |currency, detail|
          date = detail['date'].strftime('%Y-%m-%d')
          value = detail['value']
          puts "  #{currency} #{value} (#{date})"
        end
      end

      def print_exchange_rates(source, date, rates)
        date_str = (date || Time.now).strftime('%Y-%m-%d')
        puts "Exchange rates for #{source} on #{date_str}"
        rates.each do |currency, value|
          puts "  #{currency} #{value}"
        end
      end
    end
  end
end
