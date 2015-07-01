require "rails_helper"

describe Greenhouse::CandidatesImporter do
  let(:namely_fields) do
    ro = JSON.parse(
      File.read("spec/fixtures/api_responses/fields_with_greenhouse.json")
    )
    ro.fetch("fields").map do |object|
      Namely::Model.new(nil, object)
    end
  end
  let(:mailer) { double :mailer, delay: delay }
  let(:secret_key) { 'secret_key' }
  let(:signature) { '120 signature' }
  let(:connection_repo) { double :connection_repo, find_by: connection }
  let(:user) do
    double(
      :user,
      email: "test@example.com",
      namely_connection: namely_connection,
      namely_fields: double(:fields, all: namely_fields)
    )
  end
  let(:namely_connection) { double(:namely_connection) }
  let(:connection) { double :connection, user: user }
  subject(:candidates_importer) { described_class.new(mailer,
                                                      connection_repo,
                                                      params,
                                                      secret_key,
                                                      signature) }
  describe '#import' do
    context 'when payload is a ping' do
      let(:params) do
        {
          payload: {
            web_hook_id: -1
          }
        }
      end

      context 'when not proper signature is send' do
        let(:user) { build_stubbed(:user) }

        it 'raises an error' do
          allow_any_instance_of(Greenhouse::ValidRequesterPolicy).to(
            receive(:valid?) { false })

          expect {
            candidates_importer.import
          }.to raise_error(Greenhouse::CandidatesImporter::Unauthorized)
        end

        it "sends an invalid authentication message and logs an error" do
          allow_any_instance_of(Greenhouse::ValidRequesterPolicy).
            to(receive(:valid?) { false })

          mail = double(ConnectionMailer, deliver: true)
          allow(ConnectionMailer).
            to receive(:authentication_notification).
            with(email: user.email, connection_type: "greenhouse").
            and_return(mail)

          exception_class = Greenhouse::CandidatesImporter::Unauthorized
          exception_message = "Invalid authentication for Greenhouse"
          expect(Rails.logger).to receive(:error).with(
            "#{exception_class} error #{exception_message} for " \
            "user_id: #{user.id}"
          )
          expect { candidates_importer.import }.to raise_error(
            exception_class
          )
          expect(mail).to have_received(:deliver)
        end
      end
    end

    context 'when payload is not a ping' do
      let(:params) do
        {payload: {
          'application' => {
            'candidate' => {
            }
          }
        }}
      end
      let(:importer) { double :importer, success?: true }
      let(:delay) { double :delay }
      before { allow_any_instance_of(Greenhouse::ValidRequesterPolicy).to(
          receive(:valid?) { true }) }

      it 'tries to import a candidate' do
        allow(delay).to receive(:successful_import).with(user, "")

        expect_any_instance_of(NamelyImporter).to receive(:single_import).
          with(params[:payload]) { importer }

        candidates_importer.import
      end

      it 'sends a successful import email' do
        allow_any_instance_of(NamelyImporter).to receive(:single_import).
          with(params[:payload]) { importer }

        expect(delay).to receive(:successful_import).with(user, "")

        candidates_importer.import
      end

      context 'when the import fails' do
        let(:importer) { double :importer, success?: false }
        let(:delay) { double :delay }
        it 'sends an failure email' do
          allow_any_instance_of(NamelyImporter).to receive(:single_import).
            with(params[:payload]) { importer }
          expect(delay).to receive(:unsuccessful_import).with(user, '', importer)

          candidates_importer.import
        end
      end
    end
  end
end
