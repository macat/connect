module NetSuite
  class BulkExport
    def initialize(users)
      @users = users
    end

    def export
      @users.ready_to_sync_with(:net_suite).each do |user|
        Delayed::Job.enqueue SyncJob.new(:net_suite, user.id)
      end
    end
  end
end
