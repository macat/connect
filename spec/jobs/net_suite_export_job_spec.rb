require "rails_helper"
describe NetSuiteExportJob do
  describe "perform" do
    # context "with an invalid employee" do
    #   it "returns a failure result" do
    #     profile = stub_profile
    #     exception = double(
    #       :exception,
    #       response: { "message" => "invalid employee" }.to_json,
    #       http_code: 499
    #     )
    #     error = NetSuite::ApiError.new(exception)
    #     net_suite = stub_net_suite { raise error }




    #     results = perform_export(net_suite: net_suite, profiles: [profile])

    #     expect(results.map(&:success?)).to eq([false])
    #     expect(results.map(&:error)).to eq([error.to_s])
    #     expect(profile).not_to have_received(:update)
    #   end
    # end
  end
end