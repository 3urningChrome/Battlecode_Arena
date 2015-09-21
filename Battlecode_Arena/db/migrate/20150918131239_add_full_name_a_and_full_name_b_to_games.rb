class AddFullNameAAndFullNameBToGames < ActiveRecord::Migration
  def change
    add_column :games, :full_name_A, :string
    add_column :games, :full_name_B, :string
  end
end
