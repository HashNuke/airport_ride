class AddTravelStampToJourneys < ActiveRecord::Migration
  def change
    add_column :journeys, :travel_stamp, :datetime
  end
end
