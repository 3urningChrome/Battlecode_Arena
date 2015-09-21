class RemoveRetiredFromCompetitors < ActiveRecord::Migration
  def change
    remove_column :competitors, :retired, :boolean
  end
end
