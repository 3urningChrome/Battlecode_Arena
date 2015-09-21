class AddFullNameAAndFullNameBToGames < ActiveRecord::Migration
  def change
    add_column :games, :full_name_a, :string
    add_column :games, :full_name_b, :string
  end
end
