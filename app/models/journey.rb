class Journey < ActiveRecord::Base

  has_many :ride_requests
  belongs_to :user
  
  before_save :generate_travel_time

  def generate_travel_time
    self.travel_time = self.travel_stamp.to_formatted_s(:number)[0..11]
  end
end
