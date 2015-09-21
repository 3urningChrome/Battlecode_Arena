# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
maps = Map.create([{ name: 'barren'}, { name: 'border'}, { name: 'bunker'}])


#Competitor.create :name => "Destroyer", :team => "Team1", :active => true, :ai  => File.open(File.join(Rails.root, 'test.jar')), :Elo => 1500, :wins => 0, :losses => 0
#Competitor.create :name => "Target", :team => "Team1", :active => true, :ai  => File.open(File.join(Rails.root, 'test.jar')), :Elo => 1500, :wins => 0, :losses => 0
#Competitor.create :name => "Sitting Duck", :team => "Team1", :active => true, :ai  => File.open(File.join(Rails.root, 'test.jar')), :Elo => 1500, :wins => 0, :losses => 0

#50.times do |i|
#Competitor.create :name => i, :team => "Team#{i}", :active => true, :ai  => File.open(File.join(Rails.root, 'test.jar')), :Elo => i, :wins => 0, :losses => 0    
#end

#games = Game.create([{team: "not telling", teamA: "Destroyer", teamB: "Sitting Duck", map: "barren"}])