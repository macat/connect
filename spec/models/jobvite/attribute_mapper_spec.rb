require "rails_helper"

describe Jobvite::AttributeMapper do
  describe "#call" do
    it "transforms a Jobvite candidate into a Hash appropriate for the Namely API" do
      mapper = described_class.new
      jobvite_candidate = double(
        "jobvite_candidate",
        e_id: "edO1Ggwt",
        email: "crash.override@example.com",
        first_name: "Dade",
        last_name: "Murphy",
        start_date: "2014-01-02",
        gender: "Undefined",
      )

      expect(mapper.call(jobvite_candidate)).to eq(
        first_name: "Dade",
        last_name: "Murphy",
        email: "crash.override@example.com",
        user_status: "active",
        start_date: "2014-01-02",
        jobvite_id: "edO1Ggwt",
      )
    end

    it "maps genders correctly" do
      mapper = described_class.new
      expected_mapping = {
        "Male" => "Male",
        "Female" => "Female",
        "Declined to Self Identify" => nil,
        "Undefined" => nil,
        "UNEXPECTED VALUE" => nil,
      }

      expected_mapping.each do |jobvite_gender, namely_gender|
        jobvite_candidate = double(
          "jobvite_candidate",
          e_id: "edO1Ggwt",
          first_name: "Sam",
          last_name: "Smith",
          email: "user@example.com",
          start_date: Date.today.iso8601,
          gender: jobvite_gender,
        )

        result = mapper.call(jobvite_candidate)

        expect(result[:gender]).to eq namely_gender
      end
    end

    it "doesn't include a start date if Jobvite didn't provide one" do
      mapper = described_class.new
      jobvite_candidate = double(
        "jobvite_candidate",
        e_id: "edO1Ggwt",
        first_name: "Kate",
        last_name: "Libby",
        email: "acid.burn@example.com",
        start_date: nil,
        gender: "Female",
      )

      result = mapper.call(jobvite_candidate)

      expect(result).not_to have_key(:start_date)
    end
  end

  describe "#namely_identifier_field" do
    it "returns the custom Namely profile field that stores the Jobvite ID" do
      mapper = described_class.new

      expect(mapper.namely_identifier_field).to eq :jobvite_id
    end
  end

  describe "#identifier" do
    it "returns the Jobvite ID of a given candidate" do
      jobvite_candidate = double("jobvite_candidate", e_id: "MY_UNIQUE_ID")
      mapper = described_class.new

      expect(mapper.identifier(jobvite_candidate)).to eq "MY_UNIQUE_ID"
    end
  end

  describe "#readable_name" do
    it "returns a human-readable representation of the candidate" do
      jobvite_candidate = double(
        "jobvite_candidate",
        first_name: "Kate",
        last_name: "Libby",
        e_id: "MY_UNIQUE_ID",
      )
      mapper = described_class.new

      expect(mapper.readable_name(jobvite_candidate)).
        to eq "Kate Libby (MY_UNIQUE_ID)"
    end
  end
end
