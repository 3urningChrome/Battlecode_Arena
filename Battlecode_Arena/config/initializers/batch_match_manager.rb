require 'rufus-scheduler'
require 'fileutils'

scheduler = Rufus::Scheduler.new
bin_scheduler = Rufus::Scheduler.new

@arena_path = 'bin/battlecode/arena_temp'
@battlecode_path = 'bin/battlecode'
@battlecode_bin_path = 'bin/battlecode/bin'
@output_path = File.join(@battlecode_path, 'log')
@battlecode_config = "#{@battlecode_path}/bc.conf"
@battlecode_file_path = 'public/downloads/game'

TIMEOUT = 90


#Test if submission has a bin or not:
def does_bin_already_exist?(competitor_name)
  return true if File.exists?("#{@battlecode_path}/bin/#{competitor_name}")
  return false
end

# run extract Jar file for Submission
def extract_jar_file(competitor_name)
  competitor = Competitor.where("name = ?", competitor_name).first
  return if competitor == nil
  Dir.chdir(@arena_path) do
    puts "finding jar from: #{Rails.root}/public#{competitor.ai}"
    %x[jar -xvf "#{Rails.root}/public#{competitor.ai}"]
  end
end

# rename whatever submission has been given to Sumbission_name
def rename_class_folder_to_competitor_name (submission_name)
  Dir.foreach(@arena_path) do |item|
    next if item == '.' or item == '..'
    FileUtils.rm_rf("#{@arena_path}/#{item}") if item == 'META-INF'
  end
end

#move Submission <name> from arena_temp to Bin
def move_competitor_name_from_arena_temp_to_battlecode_bin(competitor_name)
  return false unless Dir.exists?("#{@arena_path}/#{competitor_name}")
  FileUtils.mv "#{@arena_path}/#{competitor_name}", "#{@battlecode_bin_path}/#{competitor_name}"
end

# Find any requested Games not yet played
def get_unplayed_games()
  return Game.where("winner is ?", nil).order(:created_at)
end

#Generate games between competitors who have not yet played
def get_auto_games()
  batch_games = Array.new
  batch_competitors = Competitor.where("active = ?", true).order(:updated_at).reverse_order
  maps = Map.all
  batch_competitors.each do |teamA|
    batch_competitors.each do |teamB|
      if teamA.name != teamB.name then
        maps.each do |map|
          game_exists = Game.where("full_name_A = ? AND full_name_B = ? AND map = ?", "#{teamA.get_full_name()}", "#{teamB.get_full_name()}", map.name).first
          batch_games.push(Game.new(:team => "AutoGen", :teamA => "#{teamA.name}", :teamB => "#{teamB.name}", :map => map.name)) if game_exists.nil?
        end
      end
    end
  end
  return batch_games
end

#Start games in a new thread. as sometimes it never comes back. (broken submissions)
#kill thread if it takes too long. then take measure on submissions.
def handle_battlecode_game(game)
  thread_start_time = Time.now
  puts "Starting new Thread"
  running_game_thread = Thread.new do
    run_battlecode_game(game)
  end
  
  while running_game_thread.alive? do
    if Time.now - thread_start_time < TIMEOUT
      sleep 1
      next
    end
    #time ran out. assume submission broken.
    puts "Killing Thread"
    running_game_thread.kill
    check_for_broken_competitor(game.teamA)
    check_for_broken_competitor(game.teamB)
  end
end

#check if this competitor could be broken, and mark as such, and destroy games
# Could be false +'ve if two new submission fight, and one is broken. still mark as bad'
def check_for_broken_competitor(competitor_name)
  puts "Broken game for #{competitor_name}"
  games_competitor_played = Game.where("(teamA = ? OR teamB = ?) AND winner is not ?", competitor_name, competitor_name,nil)
  if games_competitor_played == 0 then
    Competitor.where("name = ?", competitor_name).first.update_attributes(:active => false, :broken => true)
    Game.where("full_name_A = ? OR full_name_B = ?", competitor_name, competitor_name).each {|pending_game| pending_game.destroy!}
  end
end

def check_for_broken_flag(competitor_name)
  return Competitor.where("full_name = ?", competitor_name).first.broken
end
#run the match
def run_battlecode_game(game)
  #skips any matches between now broken competitors.
  return if check_for_broken_flag(game.full_name_A)
  return if check_for_broken_flag(game.full_name_B)
  
   puts "setting up config"
  setup_battlecode_config(game)
  
  #run battlecode
   puts "running battlecode"
  results = %x[ant headless -file "#{@battlecode_path}/build.xml"]
  
   puts "parsing results"
  game = parse_battlecode_results_and_update_game_file(results,game)
  
  #make results file available for download
  game_id = game.get_game_id
  puts "moving from: #{@battlecode_path}/match.rms to: #{@battlecode_file_path}/#{game_id}/match.rms"
  puts "Creating: #{@battlecode_file_path}/#{game_id}"
  FileUtils.mkdir_p "#{@battlecode_file_path}/#{game_id}"
  FileUtils.mv "#{@battlecode_path}/match.rms", "#{@battlecode_file_path}/#{game_id}/match.rms"
  game.file = "#{@battlecode_file_path}/#{game_id}/match.rms"
  game.save
end

def parse_battlecode_results_and_update_game_file(results,game)
  puts "we are parsing results:"
  puts results
  winner = ""
  results.each_line do |line|
    if (line.include?("[java] [server]") && line.include?( " wins "))
      #text = '"'+ test_player+ '","' + opposing_team + '","' + map + '","' +  line.sub("[java] [server]","").squeeze(' ').chomp + '"'
      winner = line.split('(')[1][0,1]
    end
  end  
  #update game file with results.
  game.winner = winner=="A" ? game.teamA : game.teamB
  game.loser  = winner=="A" ? game.teamB : game.teamA
  puts "Winner: #{winner}"
  
  alter_competitor_stats(game)
  return game
end

def alter_competitor_stats(game)
  # increment win/loss
  # set alter Elo
  puts "Alter_Competitor_stats"
  winner = Competitor.where("name = ?" ,game.winner).first
  loser = Competitor.where("name = ?" ,game.loser).first
  winner.wins = winner.wins + 1
  loser.losses= loser.losses + 1
  
  #alter Elo
  puts "wins: #{winner.wins}"
  winner.save
  loser.save
end


def setup_battlecode_config(game)
    #set up config. (I know, there has to be a better way!)
  lines = IO.readlines(@battlecode_config).map do |line|
    line = 'bc.game.maps=' + game.map if(line.start_with?("bc.game.maps="))
    line = 'bc.game.team-a=' + game.teamA if(line.start_with?("bc.game.team-a="))
    line = 'bc.game.team-b=' + game.teamB if(line.start_with?("bc.game.team-b="))
    line
  end
  File.open(@battlecode_config, 'w') do |file|
    file.puts lines
  end
end

#scheduler for creating the required Bin from competitor jar files.
# Pause the other schedulers so we don't get knickers in a twist
bin_scheduler.every("20s") do
  #keep other schedulers paused
  bin_scheduler.pause
  while scheduler.paused? 
    sleep 1
  end
  scheduler.pause
  
  competitors = Competitor.all
  competitors.each do |competitor|
    puts competitor_name = competitor.name
    if not does_bin_already_exist?(competitor_name) then
      extract_jar_file(competitor_name)
      rename_class_folder_to_competitor_name(competitor_name)
      move_competitor_name_from_arena_temp_to_battlecode_bin(competitor_name)
    end
  end
  bin_scheduler.resume if bin_scheduler.paused?
  scheduler.resume if scheduler.paused?
end

#scheduler for running the matches.
# Pause the other schedulers so we don't get knickers in a twist
scheduler.every("30s") do
  #keep other schedulers paused
  scheduler.pause
  while bin_scheduler.paused? 
    sleep 1
  end
  bin_scheduler.pause
  
  batch_games = get_unplayed_games()
  batch_games = get_auto_games() unless batch_games.count > 0
  batch_games.each do |batch_game|
    batch_game.create_full_team_names()
    handle_battlecode_game(batch_game)
  end
 
  bin_scheduler.resume if bin_scheduler.paused?
  scheduler.resume if scheduler.paused?
end