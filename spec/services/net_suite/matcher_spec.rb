require "rails_helper"

describe NetSuite::Matcher do
  let(:employee1) do
    {
      "lastName" => "Wonderland",
      "firstName" => "Alex",
      "email" => "alex@example.com",
      "InternalId" => "TEST",
    }
  end
  let(:employee2) do
    {
      "lastName" => "Wonderland",
      "firstName" => "Alice",
      "email" => "alice@example.com",
      "InternalId" => "TEST2",
    }
  end
  let(:employee3) do
    {
      "lastName" => "Wonderland",
      "firstName" => "None",
      "email" => "none@example.com",
      "InternalId" => "TEST3",
    }
  end
  let(:profile1) do
    {
      "lastName" => "Wonderlandee",
      "firstName" => "Alex",
      "email" => "alex@example.com",
      "InternalId" => "TEST",
    }
  end
  let(:profile2) do
    {
      "lastName" => "Wonderland",
      "firstName" => "Alice",
      "email" => "test@example.com",
      "InternalId" => "TEST2",
    }
  end
  let(:profile3) do
    {
      "firstName" => "None",
      "lastName" => "Wonderland",
      "email" => "alice@example.com",
      "InternalId" => "",
    }
  end
  describe "#matched" do
    context "when netsuite_id matches" do
      it "returns list of matched objects" do
        matcher = described_class.new(
          fields: ["email"],
          namely_employees: [
            profile1, profile2
          ],
          netsuite_employees: [
            employee1, employee2
          ],
        )
        expect(matcher.matched_pairs).to eq([{netsuite_employee: employee1, namely_employee: profile1}])
        expect(matcher.unmatched_namely_employees).to eq([profile2])
      end
    end
    context "when netsuite_id doesn't match" do
      it "uses the fields list to match objects" do
        matcher = described_class.new(
          fields: ["email"],
          namely_employees: [
            profile2, profile3
          ],
          netsuite_employees: [
            employee2, employee3
          ],
        )
        expect(matcher.matched_pairs).to eq([{netsuite_employee: employee2, namely_employee: profile3}])
        expect(matcher.unmatched_namely_employees).to eq([profile2])
      end
      it "uses the fields list to match objects" do
        matcher = described_class.new(
          fields: ["firstName", "lastName"],
          namely_employees: [
            profile2, profile3, profile1
          ],
          netsuite_employees: [
            employee2, employee3, employee1
          ],
        )
        expect(matcher.matched_pairs).to eq([{netsuite_employee: employee2, namely_employee: profile2}, {netsuite_employee: employee3, namely_employee: profile3}])
        expect(matcher.unmatched_namely_employees).to eq([profile1])
      end
    end
  end
end



