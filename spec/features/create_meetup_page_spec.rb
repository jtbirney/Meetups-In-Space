require 'spec_helper'

feature 'user creates meetup' do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario 'user who is not signed in cannot create new meetup' do
    visit "/"
    click_link "Add New Meetup"
    expect(page).to have_content 'You must login to add a new Meetup'
  end

  scenario 'user who is signed in creates a new meetup' do
    visit '/'
    sign_in_as user
    click_link("Add New Meetup")
    expect(page).to have_content "Signed in as #{user.username}"

    fill_in('meetup_name', with: 'Voyager')
    fill_in('meetup_details', with: 'The NASA satellite, not the Star Trek ship')
    click_on('Add Meetup')

    expect(page).to have_content 'Voyager'
  end

  scenario 'user who is signed in is shown as the creator of the meetup they created' do
    visit '/'
    sign_in_as user
    click_link("Add New Meetup")
    expect(page).to have_content "Signed in as #{user.username}"

    fill_in('meetup_name', with: 'Apollo')
    fill_in('meetup_details', with: 'Going to the moon')
    click_on('Add Meetup')

    new_meetup = Meetup.last
    visit "/meetups/#{new_meetup.id}"
    expect(page).to have_content "#{user.username} - Creator"
  end

  scenario 'user who is signed in cannot create a new meetup without including a name' do
    visit '/'
    sign_in_as user
    visit "/create"
    expect(page).to have_content "Signed in as #{user.username}"

    fill_in('meetup_details', with: 'The NASA satellite, not the Star Trek ship')
    click_on('Add Meetup')

    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "New Meetup"
  end

  scenario 'user who is signed in cannot create a new meetup without including a description' do
    visit '/'
    sign_in_as user
    visit "/create"
    expect(page).to have_content "Signed in as #{user.username}"

    fill_in('meetup_name', with: 'Voyager')
    click_on('Add Meetup')

    expect(page).to have_content "Details can't be blank"
    expect(page).to have_content "New Meetup"
  end

  scenario 'user who is signed in cannot create a new meetup without including a name and a description' do
    visit '/'
    sign_in_as user
    visit "/create"
    expect(page).to have_content "Signed in as #{user.username}"

    click_on('Add Meetup')

    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Details can't be blank"
    expect(page).to have_content "New Meetup"
  end
end
