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

  desc "Experimental and dangerous: Refetch and update Tweets"
  task :refetch => :environment do
    if User.any?
      puts "Executing the update. This may take a while and/or explode."
      begin
        @user = User.first
        statuses = Status.scoped.order("tweeted_at ASC").where("raw_hash NOT LIKE '%:id_str:%'")
        puts "Still need to fix #{statuses.count} statuses"

        statuses.limit(50).each do |status|
          MAX_ATTEMPTS = 3
          num_attempts = 0
          begin
            num_attempts += 1

            begin
              hash = @user.client.status(status.sid).to_hash

              status.text                    = hash[:text]
              status.source                  = hash[:source]
              status.tweeted_at              = hash[:created_at]
              status.in_reply_to_screen_name = hash[:in_reply_to_screen_name]
              status.in_reply_to_user_id     = hash[:in_reply_to_user_id]
              status.is_retweet              = !!hash[:retweeted_status]
              status.raw_hash                = hash
              status.save!
            rescue
              status.raw_hash[:id_str] = status.sid.to_s
              status.save!
              puts "Couldn't fix #{status.sid}"
            end

            puts "Fixed #{status.sid}"

          rescue Twitter::Error::RateLimited => error
            if num_attempts <= MAX_ATTEMPTS
              # NOTE: Your process could go to sleep for up to 15 minutes but if you
              # retry any sooner, it will almost certainly fail with the same exception.
              sleep error.rate_limit.reset_in
              retry
            else
              raise
            end
          end
        end
      rescue Exception => e
        puts "Uh oh, something went wrong (#{e.class})."
      end
    else
      puts "No user was found. Please ign in via the web interface first."
    end
  end
end
