# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')
meetups = [
  {name: "Star Wars", details: "A long, long time ago", location: "A galaxy far away"},
  {name: "Mars", details: "Our next stop?", location: "The red planet"},
  {name: "Pluto", details: "A discussion of the best planet that is not a planet", location: "A galaxy far away"},
  {name: "Voyager", details: "The NASA satellite, not the Star Trek ship", location: "Saturn"}
]

meetups.each do |meetup|
  Meetup.create(meetup)
end

users = [
  {provider: 'github', uid: '324654', username: 'me', email: 'me@website.com', avatar_url: 'image.com/me' },
  {provider: 'github', uid: '34654', username: 'you', email: 'you@website.com', avatar_url: 'image.com/you' },
  {provider: 'github', uid: '32654', username: 'us', email: 'us@website.com', avatar_url: 'image.com/us' }
]

users.each do |user|
  User.create(user)
end

user_meetups = [
  { user_id: 1, meetup_id: 1 },
  { user_id: 2, meetup_id: 1 },
  { user_id: 1, meetup_id: 2, creator: true },
  { user_id: 1, meetup_id: 3 },
  { user_id: 3, meetup_id: 4, creator: true }
]

user_meetups.each do |user_meetup|
  UserMeetup.create(user_meetup)
end
