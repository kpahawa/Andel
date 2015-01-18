class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.text :travelers

      t.timestamps
    end
  end
end
