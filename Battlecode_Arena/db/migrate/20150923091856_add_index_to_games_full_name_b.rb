class AddIndexToGamesFullNameB < ActiveRecord::Migration
  def change
    add_index :games,[:full_name_b]
  end
end
