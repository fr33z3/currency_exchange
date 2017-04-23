module CurrencyExchange
  module Printers
    autoload :Console, 'currency_exchange/printers/console'
    autoload :Twitter, 'currency_exchange/printers/twitter'
    autoload :Mail, 'currency_exchange/printers/mail'

    SUPPORTED = {
      console: Console,
      twitter: Twitter,
      mail: Mail
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
