json.array!(@games) do |game|
  json.extract! game, :id, :team, :teamA, :teamB, :map, :turns, :scoreA, :scoreB, :winner, :loser, :file
  json.url game_url(game, format: :json)
end
