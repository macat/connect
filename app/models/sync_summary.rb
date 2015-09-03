class SyncSummary < ActiveRecord::Base
  belongs_to :connection, polymorphic: true
  has_many :profile_events, dependent: :destroy

  delegate :integration_id, to: :connection

  def self.create_from_results!(results:, connection:)
    transaction do
      create!(connection: connection).tap do |sync_summary|
        sync_summary.convert_results_to_profile_events(results)
      end
    end
  end

  def convert_results_to_profile_events(results)
    results.each do |result|
      profile_events.create_from_result!(result)
    end
  end
end
