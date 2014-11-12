module Jobvite
  class BulkImport
    attr_reader :status

    def initialize(users)
      @users = users
    end

    def import
      result = ImportResult.new(UserAttributeMapper.new)
      users.inject(result) do |status, user|
        status[user] = Import.new(user).import
        status
      end
    end

    private

    attr_reader :users

    class UserAttributeMapper
      def readable_name(user)
        "User #{user.namely_user_id} (#{user.subdomain})"
      end
    end
    private_constant :UserAttributeMapper
  end
end
