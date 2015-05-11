require_relative '../../../app/services/icims/candidate_importer'

describe Icims::CandidateImporter do
  subject(:service) { described_class.new(connection, mailer, params) }
  let(:connection) { double :connection, user: user }
  let(:user) { double :user, namely_connection: namely_conn }
  let(:mailer) { double :mailer, delay: delayed }
  let(:namely_conn) { double :namely_conn, profiles: namely_profiles }
  let(:params) { {} }

  describe '#import' do
    let(:delayed) { double :delayed }
    let(:candidate) { double :candidate,
                      id: -1,
                      firstname: 'Bob',
                      lastname: 'Burgers',
                      email: 'example@email.com',
                      start_date: 'start_date',
                      gender: 'Alien',
                      home_address: 'Et'}

    context 'when importing successfully' do
      let(:namely_profiles) { double :profiles, create!: true }
      it 'enqueue a successful mail delivery' do
        allow_any_instance_of(Icims::Client).to receive(:candidate) { candidate }
        expect(delayed).to receive(:successful_import).with(user,
                                                            candidate)
        service.import
      end
    end

    context 'when unsucessful import' do
      let(:namely_profiles) { double :profiles }
      it 'enqueue an unsuccessful mail delivery' do
        allow_any_instance_of(Icims::Client).to receive(:candidate) { candidate }
        allow(namely_profiles).
          to(receive(:create!) { raise Namely::FailedRequestError.new })

        expect(delayed).to receive(:unsuccessful_import)
        service.import
      end
    end

    context 'when unauthorized credentials in icims' do
      let(:namely_profiles) { double :profiles }
      it 'enqueue an unauthorized email' do
        allow_any_instance_of(Icims::Client).
          to(receive(:candidate) { raise Icims::Client::Error.new 'Unauthorized'})

        expect(delayed).to receive(:unauthorized_import).with(user, 'Unauthorized')
        service.import
      end
    end
  end
end
