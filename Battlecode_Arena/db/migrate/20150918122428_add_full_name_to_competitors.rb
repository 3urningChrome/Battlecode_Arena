class AddFullNameToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :full_name, :string
  end
end
