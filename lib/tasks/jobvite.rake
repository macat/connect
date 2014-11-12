namespace :jobvite do
  desc "Import new Jobvite candidates for all users"
  task :import => :environment do
    import = Jobvite::BulkImport.new(User.all)
    import.import
    import.status.each do |user_id, status|
      puts "User ##{user_id}: #{status}"
    end
  end
end
