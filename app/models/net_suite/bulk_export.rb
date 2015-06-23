module NetSuite
  class BulkExport
    def initialize(users)
      @users = users
    end

    def export
      @users.ready_to_sync_with(:net_suite).each do |user|
        Export.new(
          namely_profiles: user.namely_profiles.all,
          net_suite: user.net_suite_connection.client
        ).perform
      end
    end
  end
end
