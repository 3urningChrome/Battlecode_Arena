class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :team
      t.string :teama
      t.string :teamb
      t.string :map
      t.string :turns
      t.string :scorea
      t.string :scoreb
      t.string :winner
      t.string :loser
      t.string :file

      t.timestamps null: false
    end
  end
end
