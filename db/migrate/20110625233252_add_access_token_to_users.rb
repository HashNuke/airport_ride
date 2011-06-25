class AddAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :text
  end
end
