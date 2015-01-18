class RemoveIdFromTrips < ActiveRecord::Migration
  def change
    remove_column :trips, :id, :integer
  end
end
