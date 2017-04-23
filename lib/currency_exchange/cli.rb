module CurrencyExchange
  class CLI
    attr_accessor :source, :target, :date, :printers, :api

    def initialize(api, printers = [Printers::Console.new])
      @api = api
      @source = 'USD'
      @target = []
      @date = nil
      @printers = printers
    end

    def list
      data = api.list
      each_printer do |printer|
        printer.print_list data
      end
    rescue StandardError => e
      puts e
    end

    def convert(value)
      data = api.convert(value, source, target, date)

      each_printer do |printer|
        printer.print_converted(source, value, data)
      end
    rescue StandardError => e
      puts e
    end

    def highest_rates
      data = api.highest_rates(source, target)

      each_printer do |printer|
        printer.print_highest_rates(source, data)
      end
    rescue StandardError => e
      puts e
    end

    def exchange_rates
      data = api.exchange_rates(source, target, date)

      each_printer do |printer|
        printer.print_exchange_rates(source, date, data)
      end
    rescue StandardError => e
      puts e
    end

    private

    attr_reader :provider, :provider_map, :api

    def each_printer
      printers.each do |printer|
        begin
          yield printer
        rescue StandardError => e
          puts e
        end
      end
    end

    def provider
      provider_map.provider(provider_name)
    end
  end
end
