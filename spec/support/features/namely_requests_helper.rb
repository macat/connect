module Features
  def stub_namely_fields(fixture_file)
    stub_namely_data("/profiles/fields", fixture_file)
  end

  def stub_namely_data(path, fixture_file)
    stub_request(:get, %r{.*api/v1#{Regexp.escape(path)}}).
      to_return(status: 200, body: namely_fixture(fixture_file))
  end

  def namely_fixture(fixture_file)
    File.read("spec/fixtures/api_responses/#{fixture_file}.json")
  end
end
