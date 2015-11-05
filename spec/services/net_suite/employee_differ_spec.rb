require 'rails_helper'

describe NetSuite::EmployeeDiffer do
  describe '#different?' do
    subject(:differ) do
      described_class.new(namely_profile: namely, netsuite_employee: netsuite)
    end

    context 'when the Namely Profile has changed' do
      let(:namely) { build(:namely_profile, first_name: "Bobby") }
      let(:netsuite) { build(:netsuite_profile, first_name: "Bob") }

      it 'returns true' do
        expect(differ).to be_different
      end
    end

    context 'when the Namely Profile has case differences' do
      let(:namely) { build(:namely_profile, first_name: "Bob") }
      let(:netsuite) { build(:netsuite_profile, first_name: "BOB") }

      it 'returns false' do
        expect(differ).to_not be_different
      end
    end

    context 'when the Namely Profile has not changed' do
      let(:namely) { build(:namely_profile) }
      let(:netsuite) { build(:netsuite_profile) }

      it 'returns false' do
        expect(differ).to_not be_different
      end
    end
  end

  describe '#changes' do
    context 'when the Namely Profile has changed' do
      it 'returns a hash with the attribute and difference as value'
    end
  end
end
