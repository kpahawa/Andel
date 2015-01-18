class AddAddressToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :address, :text
  end
end
