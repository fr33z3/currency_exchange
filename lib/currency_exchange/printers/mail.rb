require 'mail'

module CurrencyExchange
  module Printers
    class Mail
      def initialize(config = Configuration.instance)
        @config = config
      end

      def print_list(list)
        puts 'Printing list to mail'
        message = list.join(',')
        deliver('Supported list of currencies', message)
      end

      def print_converted(source, source_value, conversions)
        puts 'Printing conversion rates to mail'

        title = "Conversions for #{source_value} #{source}"
        message = conversions.each_with_object('') do |(currency, value), msg|
          msg << "#{currency} #{value}\n"
        end

        deliver(title, message)
      end

      def print_highest_rates(source, rates)
        puts 'Printing highest rates to mail'

        title = "Highest rates for #{source}"
        message = rates.each_with_object('') do |(currency, detail), msg|
          date = detail['date'].strftime('%Y-%m-%d')
          value = detail['value']
          msg << "#{currency} #{value} (#{date})\n"
        end

        deliver(title, message)
      end

      def print_exchange_rates(source, date, rates)
        puts 'Printing exchange rates to mail'

        date_str = (date || Time.now).strftime('%Y-%m-%d')
        title = "Exchange rates for #{source} on #{date_str}"
        message = rates.each_with_object('') do |(currency, value), msg|
          msg << "#{currency} #{value}\n"
        end

        deliver(title, message)
      end

      private

      attr_reader :config

      def deliver(title, message)
        raise 'Please specify email receiver' unless config[:email_to]

        options = mail_options
        conf = config
        ::Mail.deliver do
          delivery_method :smtp, options
          from conf[:email_from]
          to conf[:email_to]
          subject title
          body message
        end
      end

      # rubocop:disable MethodLength
      def mail_options
        {
          address: config[:email_server_address],
          authentication: :login,
          domain: config[:email_domain] || config[:email_from].split('@').last,
          user_name: config[:email_username],
          password: config[:email_password],
          port: config[:email_port],
          enable_starttls_auto: true,
          tls: false,
          openssl_verify_mode: 'none'
        }
      end
      # rubocop:enable MethodLength
    end
  end
end
