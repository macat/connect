VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec/fixtures/vcr_cassettes")
  c.hook_into :webmock
  c.ignore_localhost = true
  #c.debug_logger = STDOUT

  c.filter_sensitive_data("<CLIENT_ID>") do
    Rails.configuration.namely_client_id
  end

  c.filter_sensitive_data("<CLIENT_SECRET>") do
    Rails.configuration.namely_client_secret
  end

  c.filter_sensitive_data("<JOBVITE_KEY>") { ENV.fetch("TEST_JOBVITE_KEY") }
  c.filter_sensitive_data("<JOBVITE_SECRET>") { ENV.fetch("TEST_JOBVITE_SECRET") }
  c.filter_sensitive_data("<ACCESS_TOKEN>") { ENV.fetch("TEST_NAMELY_ACCESS_TOKEN") }
  c.filter_sensitive_data("<AUTH_CODE>") { ENV.fetch("TEST_NAMELY_AUTH_CODE") }
  c.filter_sensitive_data("<REFRESH_TOKEN>") { ENV.fetch("TEST_NAMELY_REFRESH_TOKEN") }
end
