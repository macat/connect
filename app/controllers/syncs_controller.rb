class SyncsController < IntegrationController
  def create
    Delayed::Job.enqueue SyncJob.new(integration_id, current_user.id)
    connection
  end
end
