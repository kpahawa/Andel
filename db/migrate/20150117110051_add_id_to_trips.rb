class AddIdToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :id, :integer
  end
end
