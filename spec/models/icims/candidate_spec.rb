require "rails_helper"

describe Icims::Candidate do
  describe "#start_date" do
    before { Timecop.freeze }
    after { Timecop.return }

    it "returns the start date in ISO8601 format" do
      candidate = described_class.new(
        "startdate" => Date.today.strftime("%Y-%m-%d")
      )

      expect(candidate.start_date).to eq Date.today.iso8601
    end

    it "returns nil when there is no start date" do
      candidate = described_class.new(
        "startdate" => nil
      )

      expect(candidate.start_date).to be_nil
    end
  end

  describe "#name" do
    it "returns the full from the application information" do
      first_name = "Roger"
      last_name = "Rult"

      candidate = described_class.new(
        "firstname" => first_name,
        "lastname" => last_name
      )

      expect(candidate.name).to eql "#{first_name} #{last_name}"
    end
  end

  describe "#contact_number" do
    let(:candidate) { described_class.new(application) }

    context "when just a home number is present" do
      let(:application) { { "phonenumber" => "888-888-8888" } }

      it "returns the number" do
        expect(candidate.contact_number).to eql "888-888-8888"
      end
    end
  end
end
