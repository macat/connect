require 'spec_helper' 

describe Connect::Users::UserWithFullName do 
  subject(:presenter) { described_class.new(user) }

  describe "#full_name" do
    let(:user) { double :user, first_name: "Kate", last_name: "Libby" }

    it "combines the first and last names" do
      expect(presenter.full_name).to eq "Kate Libby"
    end

    context "when only first name is set" do
      let(:user) { double :user, first_name: "Kate", last_name: nil }

      it "returns that name" do
        expect(presenter.full_name).to eq "Kate"
      end
    end

    context "when only last name is set" do 
      let(:user) { double :user, first_name: nil, last_name: "Libby" }
      it "returns last name" do 
        expect(presenter.full_name).to eq "Libby"
      end
    end

    context "when no names are set" do
      let(:user) { double :user, first_name: nil, last_name: nil }
      it "returns the empty string" do
        expect(presenter.full_name).to eq ""
      end
    end
  end
end
