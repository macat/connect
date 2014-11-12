module Jobvite
  class BulkImport
    attr_reader :status

    def initialize(users)
      @users = users
    end

    def import
      @status = users.inject({}) do |status, user|
        import = Import.new(user)
        import.import
        status.merge(user.id => import.status)
      end
    end

    private

    attr_reader :users
  end
end
