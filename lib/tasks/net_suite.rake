namespace :net_suite do
  desc "Export Namely profiles to NetSuite for all users"
  task export: :environment do
    NetSuite::BulkExport.new(User.all).export
  end
end
