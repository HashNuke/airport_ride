class CreateRideRequests < ActiveRecord::Migration
  def change
    create_table :ride_requests do |t|
      t.integer :journey_id
      t.integer :for_journey_id

      t.timestamps
    end
  end
end
