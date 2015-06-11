require_relative '../../app/services/user_check_namely_field'

describe UserCheckNamelyField do
  subject(:user_check_namely_field) { described_class.new(connection) }
  let(:connection) { double(
    :connection,
    found_namely_field?: found,
    user: user,
    required_namely_field: :field_name) }
  let(:user) { double :user, namely_connection: namely_connection }
  let(:namely_connection) { double(:namely_connection, fields: fields) }

  describe '#check?' do
    context 'when namely field not found and namely account has required field' do
      let(:found) { false }
      let(:fields) { double :fields, all: [double(:field, name: :field_name)]}

      it 'update found namely field' do
        expect(connection).to receive(:update).with(found_namely_field: true)
        user_check_namely_field.check?
      end
    end
  end
end
