class AddIndexToGamesFullNameA < ActiveRecord::Migration
  def change
    add_index :games,[:full_name_a]
  end
end
