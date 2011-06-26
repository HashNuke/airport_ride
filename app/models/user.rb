class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  
  has_many :journeys
  
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def truncated_email
    t = self.email.split "@"
    u = t[0]
    if u.length > 3
      dirty_name = u[0..2] + "..."
    else
      dirty_name = u + "..."
    end
    dirty_name + '@' + t[1]
  end

end
