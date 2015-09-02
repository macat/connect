require "rails_helper"

describe ProfileEvent do
  describe ".ordered" do
    it "orders alphabetically by profile name" do
      create(:profile_event, profile_name: "NameA")
      create(:profile_event, profile_name: "NameC")
      create(:profile_event, profile_name: "NameB")

      result = ProfileEvent.ordered

      expect(result.map(&:profile_name)).to eq(%w(NameA NameB NameC))
    end
  end

  describe ".create_from_result!" do
    context "with a successful result" do
      it "creates a successful profile event" do
        sync_summary = create(:sync_summary)
        result = double(:result, name: "Name", success?: true)

        profile_event = sync_summary.profile_events.create_from_result!(result)

        expect(profile_event).to be_persisted
        expect(profile_event).to be_successful
      end
    end

    context "with an unsuccessful result" do
      it "creates an unsuccessful profile event" do
        sync_summary = create(:sync_summary)
        result = double(:result, name: "Name", success?: false)

        profile_event = sync_summary.profile_events.create_from_result!(result)

        expect(profile_event).to be_persisted
        expect(profile_event).not_to be_successful
      end
    end
  end
end
