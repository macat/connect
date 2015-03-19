module IcimsHelpers
  def hexdigest_matcher
    /[a-f0-9]+/
  end

  def icims_customer_api_url
    "https://api.icims.com/customers/2197"
  end
end

RSpec.configure do |config|
  config.include IcimsHelpers, type: :model
end
