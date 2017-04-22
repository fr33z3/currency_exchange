require 'singleton'
require 'json'

module CurrencyExchange
  class Configuration
    include Singleton
    attr_accessor :path

    def initialize
      @conf = {}
    end

    def load!
      return unless file_present?

      data = File.read(path)
      @conf = JSON.parse(data)
    end

    def save!
      File.open(path, 'w') do |f|
        f.write JSON.pretty_generate(conf)
      end
    end

    def []=(key, value)
      conf[key.to_s] = value
    end

    def [](key)
      conf[key.to_s]
    end

    private

    attr_reader :conf

    def file_present?
      File.exist? path
    end
  end
end
