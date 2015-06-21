require "rails_helper"

describe Greenhouse::CustomFields do
  let(:namely_fields) do
    raw_objects = JSON.parse(
      File.read("spec/fixtures/api_responses/fields_with_greenhouse.json")
    )
    raw_objects.fetch("fields").map do |object|
      Namely::Model.new(nil, object)
    end
  end
  let(:payload) do
    {
      "name_middle" => { "value" => "test",
                         "type" => "short_text",
                         "name" => "Middle name" },
      "level" => { "value" => "ok",
                   "type" => "long_text",
                   "name" => "Job title" },
      "notsupported" => { "value" => "", "type" => "notsupported" },
    }
  end

  describe "::match" do
    it "filters out not supported fields" do
      expect(described_class.match(payload, namely_fields)).to eql(
        "middle_name" => "test",
        "job_title" => "ok"
      )
    end
  end
end
