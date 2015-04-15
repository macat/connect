namespace :user do
  desc "Bring on emails for every user"
  task emails: :environment do
    User.all.each do |user|
      profile = user.namely_connection.profiles.find(user.namely_user_id)
      if user.email.nil? && profile.email
        user.update(email: profile.email)
      end
    end
  end
end
