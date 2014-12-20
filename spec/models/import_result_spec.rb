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

  describe '#to_a' do 
    it 'returns a list of candidates' do 
      result = described_class.new(attribute_mapper_double) 
      candidate_one = { first_name: "Mike" }
      candidate_two = { first_name: "Nolan" } 

      result[candidate_one] = candidate_one
      result[candidate_two] = candidate_two

      expect(result.to_a).to eql [candidate_one, candidate_two]
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
