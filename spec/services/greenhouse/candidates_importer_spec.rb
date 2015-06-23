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
  let(:user) { double :user, namely_connection: namely_connection }
  let(:namely_connection) do
    double(:namely_connection, fields: double(:fields, all: namely_fields))
  end
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
        it 'raises an error' do
          allow_any_instance_of(Greenhouse::ValidRequesterPolicy).to(
            receive(:valid?) { false })

          expect {
            candidates_importer.import
          }.to raise_error(Greenhouse::CandidatesImporter::Unauthorized)
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
