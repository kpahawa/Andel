class AddLatitudeAndLongitudeToRides < ActiveRecord::Migration
  def change
    add_column :rides, :latitude, :float
    add_column :rides, :longitude, :float
  end
end
