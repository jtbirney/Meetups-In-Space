class Meetup < ActiveRecord::Base
  has_many :user_meetups
  has_many :users, through: :user_meetups

  validates_presence_of :name
  validates_presence_of :details
end
