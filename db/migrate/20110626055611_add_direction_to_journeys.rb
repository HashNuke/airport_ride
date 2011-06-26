class AddDirectionToJourneys < ActiveRecord::Migration
  def change
    add_column :journeys, :direction, :string
  end
end
