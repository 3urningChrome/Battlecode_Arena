task :ring do
  puts "Bell is ringing."
end

task :battlecode_arena_batch => :environment  do
    require 'batch_match_manager'
end