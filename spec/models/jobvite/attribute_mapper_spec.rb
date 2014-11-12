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
        start_date: DateTime.new(2014, 1, 2),
        gender: "Undefined",
      )

      expect(mapper.call(jobvite_candidate)).to eq(
        first_name: "Dade",
        last_name: "Murphy",
        email: "crash.override@example.com",
        user_status: "active",
        start_date: "2014-01-02",
        gender: "not specified",
      )
    end

    it "maps genders correctly" do
      mapper = described_class.new
      expected_mapping = {
        "Male" => "male",
        "Female" => "female",
        "Declined to Self Identify" => "not specified",
        "Undefined" => "not specified",
        "UNEXPECTED VALUE" => "not specified",
      }

      expected_mapping.each do |jobvite_gender, namely_gender|
        jobvite_candidate = double(
          "jobvite_candidate",
          first_name: "Sam",
          last_name: "Smith",
          email: "user@example.com",
          start_date: DateTime.now,
          gender: jobvite_gender,
        )
        expect(mapper.call(jobvite_candidate).fetch(:gender)).to eq namely_gender
      end
    end
  end
end
