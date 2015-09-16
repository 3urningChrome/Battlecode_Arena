require 'rufus-scheduler'
require 'fileutils'

scheduler = Rufus::Scheduler.new


def thread_process_game_to_catch_bad_errors(current_game)
  thread_start_time = Time.now
  run_game_thread = Thread.new do
      process_game current_game 
  end
  
  while run_game_thread.alive? do
    if Time.now - thread_start_time > 60
      run_game_thread.kill 
      Rails.logger.info "Killed unresponsive game after 60 seconds"
# can we work out which team is the issue and ban it?
# I guess it's the one with no games played....
      @list_of_games_teamA_played = Game.where("winner = ? OR loser = ?", current_game.teamA, current_game.teamA)
      if @list_of_games_teamA_played.count == 0 then
        remove_competitor = Competitor.where("name = ?", current_game.teamA).first
        remove_competitor.active = false
        remove_competitor.broken = true
        remove_competitor.save
        #also, kill any pending games.
        @pending_games = Game.where("teamA = ? OR teamB = ?", current_game.teamA, current_game.teamA)
        @pending_games.each do |pending_game|
          pending_game.destroy!
        end
      end
     @list_of_games_teamB_played = Game.where("winner = ? OR loser = ?", current_game.teamB, current_game.teamB)
      if @list_of_games_teamB_played.count == 0 then
        remove_competitor = Competitor.where("name = ?", current_game.teamB).first
        remove_competitor.active = false
        remove_competitor.broken = true
        remove_competitor.save
        #also, kill any pending games.
        @pending_games = Game.where("teamA = ? OR teamB = ?", current_game.teamA, current_game.teamA)
        @pending_games.each do |pending_game|
          pending_game.destroy!
        end        
      end      
      return
    end
    sleep(0.5)
  end
end

def process_game(current_game) 
  Rails.logger.info "Processing game: #{current_game.id}, TeamA: #{current_game.teamA} against TeamB: #{current_game.teamB}. On Map: #{current_game.map}"
  # run battlecode for teamA,teamB,map.
  # record results in Db.
  # attach and save result file.
  @battlecode_path = File.join(Rails.root, '/bin/battlecode2015')
  @output_path = File.join(@battlecode_path, 'log')
  
  #write config file
  lines = IO.readlines("#{@battlecode_path}/bc.conf").map do |line|
    line = 'bc.game.maps=' + current_game.map if(line.start_with?("bc.game.maps="))
    line = 'bc.game.team-a=' + current_game.teamA if(line.start_with?("bc.game.team-a="))
    line = 'bc.game.team-b=' + current_game.teamB if(line.start_with?("bc.game.team-b="))
    line
  end
  File.open("#{@battlecode_path}/bc.conf", 'w') do |file|
    file.puts lines
  end
  
  #extract jar to file from upload to bin/team
  #if there is no folder in battlecode2015/bin/ called name:
  unless File.exists?("#{@battlecode_path}/bin/#{current_game.teamA}") 
    Rails.logger.info "No folder called: #{@battlecode_path}/bin/#{current_game.teamA}"
  # we need to extract it from where it was uploaded.
    #run: jar -xvf arena_submission.jar
    @competitorA = Competitor.where("name = ?", current_game.teamA).first
    Dir.chdir "#{@battlecode_path}/arena_temp"
    puts "jar -xvf #{Rails.root}/public#{@competitorA.ai}"
    result = %x[jar -xvf "#{Rails.root}/public#{@competitorA.ai}"]
    puts "Here #{result}"
    Dir.chdir Rails.root
  # change it's folder name to match name:
  #move it to battlecode2015/bin/
  #FileUtils.copy_entry @source, @destination
  end
  
  
  #run battlecode
  result = %x[ant headless -file "#{@battlecode_path}/build.xml"]
  puts "we are still running"
  result.each_line do |line|
    if (line.start_with?("     [java] [server]") && line.include?( " wins "))
      text = '"'+ test_player+ '","' + opposing_team + '","' + map + '","' +  line.sub("[java] [server]","").squeeze(' ').chomp + '"'
      @current_results << ("\n" + text)
      open(@output_path, 'a') { |f| f.puts text }
    end
  end
  
  #parse results.
  
  
  #upload results file (match.rms) to uploader for game.
  
  
  current_game.winner = current_game.teamA
  current_game.loser = current_game.teamB
  current_game.save
end

scheduler.every("10s") do
   Rails.logger.info "Running Batch Game process #{Time.now}"
   
  # pause scheduler
  scheduler.pause
   
  # select any games with winner = "" by earliest creation date.
  @batch_games = Game.where("winner is ?", nil).order(:created_at)
   
  # These are player created ones, and need to be run first.
   
  # if number of games > 0 then
  if @batch_games.count > 0 then
    #loop through each game (limit of 10)
    @batch_games.first(10).each do |batch_game|
      thread_process_game_to_catch_bad_errors batch_game
    end
  else
    #select competitors by created date. most recent first - active only.
    @batch_competitors = Competitor.where("active = ?", true).order(:updated_at).reverse_order
    @maps = Map.all
    #Rails.logger.info "Processing #{@batch_competitors.count}"
    
    #loop through competitors, playing most recent against the rest on all maps.
    @batch_competitors.each_with_index do |teamA, index|
      @batch_competitors.each do |teamB|
      # check games does not exist before running it, and it's not a game against itself.
        #Rails.logger.info "checking game: #{teamA.name}/#{teamB.name}"
        if teamA.name != teamB.name then
          @maps.each do |map|
            game_exists = Game.where("teamA = ? AND teamB = ? AND map = ?", teamA.name, teamB.name, map.name)
            if game_exists.count > 0 then
             # Rails.logger.info "Game already played before: #{teamA.name}/#{teamB.name}/#{map.name} "
            else
              batch_game = Game.new(:team => "AutoGen", :teamA => teamA.name, :teamB => teamB.name, :map => map.name)
             thread_process_game_to_catch_bad_errors batch_game
            end
          end
      # process game
        else
          #Rails.logger.info "Ignoring game with both players = #{teamA.name}/#{teamB.name}"
        end
      end
      # Keep latest 20 submissions active. Otherwise, if it's older than 24hrs deactivate it.
      if index > 20 then
        if(Time.now - teamA.updated_at) > (24 * 60 * 60) then
          teamA.active = false
          teamA.save
        end
      end
    end
  end
   
   # deactivate 'old' submissions
   # restart schedular
   scheduler.resume if scheduler.paused?
  #Rails.logger.info "finished, it's #{Time.now}"
   Rails.logger.flush
end 
