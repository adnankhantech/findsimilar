class User < ActiveRecord::Base

  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :email, :image, :fb_url
  
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :likes
  acts_as_followable
  acts_as_follower
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.extra.raw_info.email
      user.image = auth.info.image
      user.fb_url = auth.info.urls.Facebook
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
  
end
