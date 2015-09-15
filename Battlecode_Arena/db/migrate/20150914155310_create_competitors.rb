class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :team
      t.integer :Elo
      t.boolean :active
      t.integer :wins
      t.integer :losses
      t.boolean :broken

      t.timestamps null: false
    end
  end
end
