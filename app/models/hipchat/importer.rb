module Hipchat
  class Importer
    def self.import(*args)
      new(*args).import
    end

    attr_reader :token, :namely_connection

    def initialize(token:, namely_connection:)
      @token = token
      @namely_connection = namely_connection
    end

    def import
      hipchat_emails = hipchat_users.email_list
      namely_emails = namely_profiles.map { |profile| profile.email }
      new_emails = namely_emails - hipchat_emails
      new_profiles = namely_profiles.find_all { |profile| new_emails.include?(profile.email) }
      import_users(new_profiles)
      new_profiles
    end

    private

    def import_users(users)
      users.each { |user| import_user(user) }
    end

    def import_user(user)
      hipchat_users.create_user(name: "#{ user.first_name } #{ user.last_name }", email: user.email)
    end

    def namely_profiles
      @namely_emails ||= namely_connection.profiles.all
    end

    def hipchat_users
      @hipchat_users ||= Hipchat::Users.new(token)
    end
  end
end
