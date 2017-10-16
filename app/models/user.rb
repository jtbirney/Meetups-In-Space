class User < ActiveRecord::Base
  has_many :user_meetups
  has_many :meetups, through: :user_meetups

  validates_presence_of :provider
  validates_presence_of :uid
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :avatar_url

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.provider = provider
      user.uid = uid
      user.email = auth.info.email
      user.username = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
