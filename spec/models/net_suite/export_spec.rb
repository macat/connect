require "rails_helper"

describe NetSuite::Export do
  describe "#perform" do
    context "with new, valid employees" do
      it "returns a result with created profiles" do
        emails = %w(one@example.com two@example.com)
        profiles = emails.map { |email| stub_profile(email: email) }
        net_suite = stub_net_suite(success: true)

        results = perform_export(net_suite: net_suite, profiles: profiles)

        expect(results.map(&:success?)).to eq([true, true])
        expect(results.map(&:email)).to eq(emails)
        profiles.each do |profile|
          expect(net_suite).to have_received(:create_employee).with(
            first_name: profile.first_name,
            last_name: profile.last_name,
            email: profile.email,
            gender: profile.gender,
            phone: profile.home_phone
          )
        end
      end
    end

    context "with an already-exported employee" do
      it "skips that result" do
        profiles = [stub_profile({}, netsuite_id: "1234")]
        net_suite = stub_net_suite

        results = perform_export(net_suite: net_suite, profiles: profiles)

        expect(results).to be_empty
      end
    end

    context "with an invalid employee" do
      it "returns a failure result" do
        message = "invalid employee"
        profiles = [stub_profile(email: "example")]
        net_suite = stub_net_suite(success: false, message: message)

        results = perform_export(net_suite: net_suite, profiles: profiles)

        expect(results.map(&:success?)).to eq([false])
        expect(results.map(&:message)).to eq([message])
      end
    end
  end

  def build_namely_connection
    create(:user).namely_connection
  end

  def stub_profile(overrides = {}, data = {})
    data.stringify_keys.tap do |profile|
      attributes = {
        id: "83809753-615b-44ee-914b-3821fe2ee7ae",
        first_name: "Sally",
        last_name: "Smith",
        email: "sally.smith@example.com",
        start_date: "07/18/2013",
        gender: "Female",
        home_phone: "123-123-1234",
        job_title:
        {
          id: "0c601728-2658-4677-a22b-1c8653b431ae",
          title: "CEO"
        }
      }.merge(overrides)

      attributes.each do |name, value|
        allow(profile).to receive(name).and_return(value)
      end
    end
  end

  def stub_net_suite(arguments = {})
    double("net_suite").tap do |net_suite|
      response = arguments.stringify_keys.except("success")
      allow(response).to receive(:success?).and_return(arguments[:success])
      allow(net_suite).to receive(:create_employee).and_return(response)
    end
  end

  def perform_export(net_suite:, profiles:)
    NetSuite::Export.new(
      net_suite: net_suite,
      namely_profiles: profiles
    ).perform
  end
end
