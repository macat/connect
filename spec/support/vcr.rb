VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec/fixtures/vcr_cassettes")
  c.hook_into :webmock
  c.ignore_localhost = true

  c.filter_sensitive_data("<CLIENT_ID>") do
    Rails.configuration.namely_client_id
  end

  c.filter_sensitive_data("<CLIENT_SECRET>") do
    Rails.configuration.namely_client_secret
  end
end
