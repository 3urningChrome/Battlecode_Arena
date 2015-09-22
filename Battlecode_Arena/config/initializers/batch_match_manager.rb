
require 'rufus-scheduler'
require 'fileutils'

scheduler = Rufus::Scheduler.new
bin_scheduler = Rufus::Scheduler.new

#if ENV['DYNO'].match(/^worker\./)
#  process
#end
#
if Rails.env.production?
  if ENV['DYNO'].match(/^web\./)
    scheduler.every("30s") do

      scheduler.pause
    %x[heroku run rake batch.process.rake]
  
#  bin_scheduler.resume if bin_scheduler.paused?
      scheduler.resume if scheduler.paused?
    end
  end
end