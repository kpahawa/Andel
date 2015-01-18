json.array!(@trips) do |trip|
  json.extract! trip, :id, :id, :travelers
  json.url trip_url(trip, format: :json)
end
