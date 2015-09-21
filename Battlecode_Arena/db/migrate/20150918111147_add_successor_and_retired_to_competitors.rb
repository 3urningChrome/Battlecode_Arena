class AddSuccessorAndRetiredToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :successor, :string
    add_column :competitors, :retired, :boolean
  end
end
