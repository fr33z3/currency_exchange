require "bundler/setup"
require "currency_exchange"
require "webmock/rspec"

WebMock.disable_net_connect!
require_relative './support/webmock/stubs'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.before(:each) do
    stub_currency_layer_requests!
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
