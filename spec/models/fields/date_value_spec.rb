require "rails_helper"

describe Fields::DateValue do
  describe "#to_raw" do
    it "returns the original value" do
      expect(Fields::DateValue.new(5).to_raw).to eq(5)
    end
  end

  describe "#to_s" do
    it "returns the original value as a string" do
      expect(Fields::DateValue.new(5).to_s).to eq("5")
    end
  end

  describe "#to_date" do
    it "parses a Namely date string" do
      expect(Fields::DateValue.new("08/26/1986").to_date).
        to eq(Date.new(1986, 8, 26))
    end
  end
end