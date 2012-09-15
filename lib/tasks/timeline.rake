# encoding: UTF-8

namespace :timeline do

  desc "Import all possible statuses from the Twitter API"
  task :initial_import => :environment do
    if User.any?
      puts "Executing the import. This may take a while and/or explode."
      begin
        Status.initial_import_for_user(User.first.id)
      rescue Exception => e
        puts "Uh oh, something went wrong."
      end
    else
      puts "No user was found. Please ign in via the web interface first."
    end
  end

  desc "Update your depository timeline with your latest Tweets"
  task :update => :environment do
    if User.any?
      puts "Executing the update. This may take a while and/or explode."
      puts "This update will only archive your 200 latest tweets."
      begin
        Status.import_latest_for_user(User.first.id)
      rescue Exception => e
        puts "Uh oh, something went wrong."
      end
    else
      puts "No user was found. Please ign in via the web interface first."
    end
  end
end
