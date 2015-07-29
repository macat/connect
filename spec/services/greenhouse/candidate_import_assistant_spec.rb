require "rails_helper"

describe Greenhouse::CandidateImportAssistant do
  describe "#initialize" do
    it "sets #signature" do
      import_assistant = Greenhouse::CandidateImportAssistant.new(
        assistant_arguments: { signature: "foo" },
        context: candidate_importer_double
      )

      expect(import_assistant.signature).to eq("foo")
    end
  end

  describe "#candidate" do
    it "returns a candidate from contextual params" do
      candidate = candidate_double
      context = candidate_importer_double
      import_assistant = Greenhouse::CandidateImportAssistant.new(
        assistant_arguments: { signature: "foo" },
        context: context
      )
      allow(Greenhouse::CandidateName).to receive(:new).
        and_return(candidate)

      expect(import_assistant.candidate).to eq(candidate)
    end
  end

  describe "#attribute_mapper" do
    it "returns an attribute mapper object" do
      context = candidate_importer_double
      import_assistant = Greenhouse::CandidateImportAssistant.new(
        assistant_arguments: { signature: "foo" },
        context: context
      )

      expect(import_assistant.attribute_mapper).to be_instance_of(
        Greenhouse::AttributeMapper
      )
    end
  end

  def candidate_importer_double
    double(
      CandidateImporter,
      connection: double(:connection),
      params: {},
      user: double(:user, namely_fields: double(:fields, all: true))
    )
  end

  def candidate_double
    double(:candidate, id: -1)
  end
end