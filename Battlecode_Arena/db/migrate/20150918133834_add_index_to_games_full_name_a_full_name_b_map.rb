class AddIndexToGamesFullNameAFullNameBMap < ActiveRecord::Migration
  def change
    add_index :games,[:full_name_a,:full_name_b,:map],unique:true
  end
end
