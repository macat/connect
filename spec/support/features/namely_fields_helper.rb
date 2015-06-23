module Features
  def stub_namely_fields(fixture_file)
    stub_request(:get, %r{.*api/v1/profiles/fields}).
      to_return(status: 200, body: namely_fields_fixture(fixture_file))
  end

  def namely_fields_fixture(fixture_file)
    File.read("spec/fixtures/api_responses/#{fixture_file}.json")
  end
end
