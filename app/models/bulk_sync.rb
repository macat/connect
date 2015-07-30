class BulkSync
  def initialize(integration_id:, users:)
    @integration_id = integration_id
    @users = users
  end

  def sync
    @users.ready_to_sync_with(@integration_id).each do |user|
      Delayed::Job.enqueue SyncJob.new(@integration_id, user.id)
    end
  end
end
