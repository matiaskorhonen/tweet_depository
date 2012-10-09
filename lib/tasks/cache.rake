# encoding: UTF-8

namespace :cache do

  desc "Clear the Rails cache"
  task :clear => :environment do
    if Rails.cache.clear
      puts "The cache was cleared"
    else
      abort "Something went wrong"
    end
  end

end
