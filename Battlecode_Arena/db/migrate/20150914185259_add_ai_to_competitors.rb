class AddAiToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :ai, :string
  end
end
