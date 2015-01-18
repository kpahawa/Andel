json.array!(@rides) do |ride|
  json.extract! ride, :id, :address, :travelers
  json.url ride_url(ride, format: :json)
end
