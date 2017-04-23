module CurrencyExchange
  module Printers
    autoload :Console, 'currency_exchange/printers/console'
    autoload :Twitter, 'currency_exchange/printers/twitter'

    SUPPORTED = {
      console: Console,
      twitter: Twitter
    }.freeze

    def self.supported_printers(names)
      names.each_with_object([]) do |name, printers|
        if SUPPORTED.keys.include?(name.to_sym)
          printers << SUPPORTED[name.to_sym].new
        end
      end
    end
  end
end
