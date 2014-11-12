require "rails_helper"

describe Jobvite::Candidate do
  describe "#start_date" do
    before { Timecop.freeze }
    after { Timecop.return }

    it "returns the start date in ISO8601 format" do
      candidate = described_class.new("application" => {
        "startDate" => DateTime.now.to_i * 1000
      })

      expect(candidate.start_date).to eq Date.today.iso8601
    end

    it "returns nil when there is no start date" do
      candidate = described_class.new("application" => {
        "startDate" => nil
      })

      expect(candidate.start_date).to be_nil
    end
  end

  describe "#gender" do
    it "returns the gender from the application information" do
      gender = double("gender")
      candidate = described_class.new("application" => { "gender" => gender })

      expect(candidate.gender).to eq gender
    end
  end
end
