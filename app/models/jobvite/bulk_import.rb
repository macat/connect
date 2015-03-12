module Jobvite
  class BulkImport
    attr_reader :status

    def initialize(users)
      @users = users
    end

    def import
      result = ImportResult.new(UserAttributeMapper.new)
      users.inject(result) do |status, user|
        status[user] = new_importer(user).import
        status
      end
    end

    private

    attr_reader :users

    def new_importer(user)
      Importer.new(
        user,
        connection: user.jobvite_connection,
        client: Client.new(user.jobvite_connection),
        namely_importer: NamelyImporter.new(
          attribute_mapper: AttributeMapper.new,
          namely_connection: user.namely_connection,
        )
      )
    end

    class UserAttributeMapper
      def readable_name(user)
        "User #{user.namely_user_id} (#{user.subdomain})"
      end
    end
    private_constant :UserAttributeMapper
  end
end
