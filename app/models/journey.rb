class Journey < ActiveRecord::Base

  has_many :ride_requests
  belongs_to :user
  
  before_save :generate_travel_time

  def generate_travel_time
    self.travel_time = self.travel_stamp.to_i
  end
  
  def possible_matches
    t_time = self.travel_time

    from_time = t_time - 3600
    to_time = t_time + 3600
    jid = self.id
    #Journey.find (:all,:conditions => {:travel_time => from_time..to_time})
    
    direction = self.direction
    
    Journey.find(:all, :conditions => ["travel_time > ? AND travel_time < ? AND direction == ? AND id != ?", from_time, to_time, direction, jid])
  end

end
