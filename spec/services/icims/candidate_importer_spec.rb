require "rails_helper"

describe Icims::CandidateImporter do
  subject(:service) { described_class.new(connection, mailer, params) }
  let(:connection) { double :connection, user: user }
  let(:user) do
    double(
      :user,
      email: "test@example.com",
      id: 1,
      namely_connection: namely_conn
    )
  end
  let(:mailer) { double :mailer, delay: delayed }
  let(:namely_conn) { double :namely_conn, profiles: namely_profiles }
  let(:params) { {} }

  describe "#import" do
    let(:delayed) { double :delayed }
    let(:candidate) { double :candidate,
                      id: -1,
                      firstname: "Bob",
                      lastname: "Burgers",
                      email: "example@email.com",
                      start_date: "start_date",
                      gender: "Alien",
                      home_address: "Et" }

    context "when importing successfully" do
      let(:namely_profiles) { double :profiles, create!: true }
      it "enqueues a successful mail delivery" do
        allow_any_instance_of(Icims::Client).to receive(:candidate) { candidate }
        expect(delayed).to receive(:successful_import).
          with(
            candidate: candidate,
            email: user.email,
            integration_id: "icims",
          )

        service.import
      end
    end

    context "when importing unsuccessfully" do
      let(:namely_profiles) { double :profiles }
      it "enqueues an unsuccessful mail delivery" do
        allow_any_instance_of(
          Icims::Client
        ).to receive(:candidate) { candidate }
        allow(namely_profiles).
          to(receive(:create!) { raise Namely::FailedRequestError.new })

        expect(delayed).to receive(:unsuccessful_import)
        service.import
      end
    end

    context "when unauthorized credentials in icims" do
      let(:namely_profiles) { double :profiles }
      it "logs the error and sends an authentication notification email" do
        exception = Icims::Client::Error.new("Unauthorized")
        allow_any_instance_of(Icims::Client).
          to(receive(:candidate) { raise exception })

        user_id = user.id
        allow(user).to receive(:send_connection_notification).
          with(integration_id: "icims", message: exception.message)
        expect(Rails.logger).to receive(:error).with(
          "Icims::Client::Error error Unauthorized for user_id: #{user_id} " \
          "with iCIMS"
        )
        expect(user).to receive(:send_connection_notification).
          with(integration_id: "icims", message: exception.message)

        service.import
      end
    end
  end
end
