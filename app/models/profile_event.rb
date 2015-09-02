class ProfileEvent < ActiveRecord::Base
  belongs_to :sync_summary

  # Intended to be called via the association from a SyncSummary which will
  # provide the required `sync_summary_id` attribute.
  def self.create_from_result!(result)
    create!(profile_name: result.name, successful: result.success?)
  end

  def self.ordered
    order(profile_name: :asc)
  end
end
