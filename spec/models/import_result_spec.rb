require "rails_helper"

describe ImportResult do
  describe "delegations" do
    subject { described_class.new(nil) }

    it { should delegate_method(:[]).to(:results) }
    it { should delegate_method(:[]=).to(:results) }
  end

  describe "#to_s" do
    it "pretty-prints" do
      result = described_class.new(attribute_mapper_double)
      failed_candidate = { first_name: "Dade" }
      successful_candidate = { first_name: "Kate" }

      result[failed_candidate] = :failure
      result[successful_candidate] = :success

      expect(result.to_s).to eq "Dade: failure\nKate: success\n"
    end

    it "accepts an optional formatting string" do
      result = described_class.new(attribute_mapper_double)
      failed_candidate = { first_name: "Dade" }
      successful_candidate = { first_name: "Kate" }

      result[failed_candidate] = :failure
      result[successful_candidate] = :success

      expect(result.to_s("%{candidate} is a %{result}\n")).
        to eq "Dade is a failure\nKate is a success\n"
    end
  end

  describe "#each" do
    it "iterates over a list of candidates" do
      expected = [
        { candidate: { first_name: "Mike" }, result: :failure },
        { candidate: { first_name: "Nolan" }, result: :success }
      ]
      candidate_one = { first_name: "Mike" }
      candidate_two = { first_name: "Nolan" }

      result = described_class.new(attribute_mapper_double)
      result[candidate_one] = :failure
      result[candidate_two] = :success

      actual = []
      result.each { |candidate| actual << candidate }

      expect(actual).to eql expected

    end
  end

  def attribute_mapper_double
    mapper = double("attribute_mapper")
    allow(mapper).to receive(:readable_name) do |candidate|
      candidate[:first_name]
    end
    mapper
  end
end
