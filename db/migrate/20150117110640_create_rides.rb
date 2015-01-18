class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :address
      t.text :travelers

      t.timestamps
    end
  end
end
