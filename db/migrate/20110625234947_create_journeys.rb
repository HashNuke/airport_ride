class CreateJourneys < ActiveRecord::Migration
  def change
    create_table :journeys do |t|
      t.column :travel_time, 'bigint'
      t.string :place
      t.integer :user_id

      t.timestamps
    end
  end
end
