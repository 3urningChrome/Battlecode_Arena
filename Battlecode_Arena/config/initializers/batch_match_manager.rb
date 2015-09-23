
require 'rufus-scheduler'
require 'fileutils'

scheduler = Rufus::Scheduler.new
bin_scheduler = Rufus::Scheduler.new

#if ENV['DYNO'].match(/^worker\./)
#  process
#end
#
#puts "Rails production? #{Rails.env.production?}"
#if Rails.env.development?
#  puts "Dyno? #{ENV['DYNO']}"
#  if ENV['DYNO'].match(/^web\./)
#    scheduler.every("30s") do
#
#      scheduler.pause
#    %x[rake batch.process.rake]
#  
#  bin_scheduler.resume if bin_scheduler.paused?
#      scheduler.resume if scheduler.paused?
#    end
#  end
#end

%x[rake batch.process.rake] if Rails.env.development?