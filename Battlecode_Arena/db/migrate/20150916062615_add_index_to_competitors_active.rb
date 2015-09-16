class AddIndexToCompetitorsActive < ActiveRecord::Migration
  def change
    add_index :competitors, :active
  end
end
