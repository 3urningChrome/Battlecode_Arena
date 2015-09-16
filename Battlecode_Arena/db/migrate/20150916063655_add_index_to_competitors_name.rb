class AddIndexToCompetitorsName < ActiveRecord::Migration
  def change
    add_index :competitors, :name, unique:true
  end
end
