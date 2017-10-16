require 'spec_helper'

feature 'user views meetup show page' do
  let(:meetup) do
    FactoryGirl.create(:meetup)
  end

  scenario 'view meetup detail page' do

    visit "/meetups/#{meetup.id}"
    expect(page).to have_content(meetup.name)
    expect(page).to have_content(meetup.details)
    expect(page).to have_content(meetup.location)
  end

  scenario 'meetup show page has users who have joined the meetup and creator of meetup' do
    meetup
    new_user1 = FactoryGirl.create(:user)
    meetup.users << new_user1
    new_user_meetup = new_user1.user_meetups.first
    new_user_meetup.creator = true
    new_user_meetup.save!
    new_user2 = FactoryGirl.create(:user)
    meetup.users << new_user2
    id = meetup.id

    visit '/'
    sign_in_as new_user1
    visit "/meetups/#{id}"

    expect(page).to have_content new_user1.username
    expect(page.find("#user#{new_user1.id}")['src']).to have_content new_user1.avatar_url
    expect(page).to have_content "#{new_user1.username} - Creator"
    expect(page).to have_content new_user2.username
    expect(page.find("#user#{new_user2.id}")['src']).to have_content new_user2.avatar_url
  end

  scenario 'user that is signed in can click a button to be added to the meetup' do
    new_user1 = FactoryGirl.create(:user)
    id = meetup.id
    visit '/'
    sign_in_as new_user1
    visit "/meetups/#{id}"

    click_on 'Add Me to This Meetup'
    expect(page).to have_content 'You have been added to this meetup'
    expect(page.find('#attendees')).to have_content new_user1.username
  end

  scenario 'user that is not signed in clicks a button to be added to the meetup and is asked to log in' do
    id = meetup.id
    visit "/meetups/#{id}"
    click_on 'Add Me to This Meetup'
    expect(page).to have_content 'You must login to be added to this meetup'
  end
end
