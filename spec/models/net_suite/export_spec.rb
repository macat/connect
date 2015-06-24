require "rails_helper"

describe NetSuite::Export do
  describe "#perform" do
    context "with new, valid employees" do
      it "returns a result with created profiles" do
        emails = %w(one@example.com two@example.com)
        profiles = emails.map { |email| stub_profile(email: email) }
        net_suite = stub_net_suite(success: true, internalId: "1234")

        results = perform_export(net_suite: net_suite, profiles: profiles)

        expect(results.map(&:success?)).to eq([true, true])
        expect(results.map(&:updated?)).to eq([false, false])
        expect(results.map(&:email)).to eq(emails)
        profiles.each do |profile|
          expect(net_suite).to have_received(:create_employee).with(
            firstName: profile.first_name,
            lastName: profile.last_name,
            email: profile.email,
            gender: "_female",
            phone: profile.home_phone,
            subsidiary: { internalId: 1 },
            title: profile.job_title[:title]
          )
          expect(profile).to have_received(:update).with(netsuite_id: "1234")
        end
      end
    end

    context "with an already-exported employee" do
      it "returns a result with updated profiles" do
        profile = stub_profile({}, netsuite_id: "1234")
        net_suite = stub_net_suite(success: true)

        results = perform_export(net_suite: net_suite, profiles: [profile])

        expect(results.map(&:email)).to eq([profile.email])
        expect(results.map(&:updated?)).to eq([true])
        expect(net_suite).to have_received(:update_employee).with(
          profile["netsuite_id"],
          firstName: profile.first_name,
          lastName: profile.last_name,
          email: profile.email,
          gender: "_female",
          phone: profile.home_phone,
          subsidiary: { internalId: 1 },
          title: profile.job_title[:title]
        )
      end
    end

    context "with an invalid employee" do
      it "returns a failure result" do
        message = "invalid employee"
        profile = stub_profile(email: "example")
        net_suite = stub_net_suite(success: false, message: message)

        results = perform_export(net_suite: net_suite, profiles: [profile])

        expect(results.map(&:success?)).to eq([false])
        expect(results.map(&:message)).to eq([message])
        expect(profile).not_to have_received(:update)
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

      allow(profile).to receive(:update)

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
      allow(net_suite).to receive(:update_employee).and_return(response)
    end
  end

  def perform_export(net_suite:, profiles:)
    NetSuite::Export.new(
      net_suite: net_suite,
      namely_profiles: profiles
    ).perform
  end
end
