class Journey < ActiveRecord::Base

  has_many :ride_requests
  belongs_to :user

end
