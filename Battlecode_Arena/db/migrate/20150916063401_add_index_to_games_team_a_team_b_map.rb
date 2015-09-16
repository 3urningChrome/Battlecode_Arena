class AddIndexToGamesTeamATeamBMap < ActiveRecord::Migration
  def change
    add_index :games, [:teamA,:teamB,:map], unique:true
  end
end
