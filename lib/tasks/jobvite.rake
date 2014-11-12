namespace :jobvite do
  desc "Import new Jobvite candidates for all users"
  task :import => :environment do
    status = Jobvite::BulkImport.new(User.all).import
    puts status.to_s("%{candidate}\n\n%{result}\n\n")
  end
end
