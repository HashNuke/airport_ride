class User < ActiveRecord::Base

  has_many :journeys

  def self.create_with_omniauth(auth)
    logger.debug "AKASH: " + auth.inspect
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.email = auth["user_info"]["email"]
      user.access_token = auth["credentials"]["token"]
    end
  end

end
