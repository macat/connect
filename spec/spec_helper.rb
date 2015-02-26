require "webmock/rspec"
require 'delegate'

require 'timecop'
require 'active_support/time'

require 'wisper' 
require 'wisper/rspec/matchers'

require_relative '../app/connect/users/user_with_full_name'
require_relative '../app/connect/users/access_token_freshener'
require_relative '../app/connect/users/token_expiry'

require_relative '../app/connect/jobvite/connection_updater'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include Wisper::RSpec::BroadcastMatcher
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)
