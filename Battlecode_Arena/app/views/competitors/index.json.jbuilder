json.array!(@competitors) do |competitor|
  json.extract! competitor, :id, :name, :team, :Elo, :active, :wins, :losses, :broken, :ai
  json.url competitor_url(competitor, format: :json)
end
