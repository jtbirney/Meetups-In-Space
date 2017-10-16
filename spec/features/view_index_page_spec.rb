require 'spec_helper'

feature 'user views meetup' do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario 'view index page' do
    7.times do
      FactoryGirl.create(:meetup)
    end

    visit '/'
    expect(page).to have_content 'Episode 1'
    expect(page).to have_content 'Episode 2'
    expect(page).to have_content 'Episode 3'
    expect(page).to have_content 'Episode 4'
    expect(page).to have_content 'Episode 5'
    expect(page).to have_content 'Episode 6'
    expect(page).to have_content 'Episode 7'
  end
end
