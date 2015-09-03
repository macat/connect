require "rails_helper"

describe SyncSummary do
  describe ".create_from_results" do
    it "creates a sync summary for the connection with the given results" do
      names = %w(Billy Wendy Franko)
      results = names.map { |name| double(:result, name: name, error: nil) }
      connection = create(:net_suite_connection)

      summary = SyncSummary.create_from_results!(
        results: results,
        connection: connection
      )

      expect(summary).to be_persisted
      expect(summary.profile_events.pluck(:profile_name)).to match_array(names)
    end
  end
end
