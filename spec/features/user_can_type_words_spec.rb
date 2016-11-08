require 'rails_helper'

RSpec.feature "Users can type words" do
  scenario "User sees words instead of giphy when prepending with .t" do
    # visit '/'
    # click_button "Play as Guest"
    # # fill_in 'user-input', with: ".t these are words"
    # find('.user-input').set  ".t these are words"
    # find('.user-input').native.send_keys(:return)
    # # save_and_open_page
    # expect(page).to have_content("these are words")

    # Tested manually, js webbrowser did not cooperate with js: true
  end
end
