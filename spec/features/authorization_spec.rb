require 'rails_helper'

RSpec.feature "Authorizations", type: :feature do
  it 'registers user and authorizes him' do
    visit root_path
    click_link 'Sign Up'
    fill_in "Name",	with: "Capybara"
    fill_in "Email",	with: "capybara@email.com"
    fill_in "user_password",	with: "password"
    fill_in "user_password_confirmation",	with: "password"
    click_button 'Sign up'
    expect(page).to have_content 'Capybara'
  end

  it 'authorizes registered user' do
    user = create(:user)
    visit root_path
    click_link 'Log In'
    fill_in "Email",	with: user.email
    fill_in "user_password",	with: "password"
    click_button 'Log in'
    expect(page).to have_content user.name
  end
end
