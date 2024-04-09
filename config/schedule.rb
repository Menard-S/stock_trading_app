# Use this file to easily define all of your cron jobs.

# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Set the environment and output log file
env :PATH, ENV['PATH']
set :environment, 'development'
set :output, 'log/cron.log'

every 1.minute do
  rake "stock:update_prices"
  rake "portfolio:update_gains"
end

# Example of a job that runs every 4 days
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
