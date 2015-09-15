class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :team
      t.string :teamA
      t.string :teamB
      t.string :map
      t.string :turns
      t.string :scoreA
      t.string :scoreB
      t.string :winner
      t.string :loser
      t.string :file

      t.timestamps null: false
    end
  end
end
