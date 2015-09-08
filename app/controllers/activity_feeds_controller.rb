class ActivityFeedsController < IntegrationController
  def show
    @sync_summaries = connection.sync_summaries.ordered
  end
end
