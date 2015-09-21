class AddIndexToGamesFullNameAFullNameBMap < ActiveRecord::Migration
  def change
    add_index :games,[:full_name_A,:full_name_B,:map],unique:true
  end
end
