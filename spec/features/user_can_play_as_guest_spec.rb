require 'rails_helper'

RSpec.feature "Users can play as Guest" do
  scenario "User is assigned a guest account" do
    visit '/'
    click_button "Play as Guest"
    expect(current_path).to eq lobby_path
    expect(page).to have_content("Welcome #{User.last.name}")
  end

  scenario "Guest account is deleted upon logging out" do
    visit '/'
    click_button "Play as Guest"
    user = User.last
    expect(User.last).to eq(user)
    click_link "Logout"
    expect(User.last).not_to eq(user)
  end
end
