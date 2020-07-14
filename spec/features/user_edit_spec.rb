require 'rails_helper'

RSpec.feature "UserEdits", type: :feature do
  let!(:user) { create(:user) }
  
  it 'should edit user' do
    sign_in(user)

    visit root_path
    click_link('Edit')
    fill_in "Name",	with: "Anatoly" 
    fill_in "Company",	with: "CDG" 
    fill_in "Current password",	with: "password"
    expect {
      click_button('Update')
    }.to change { user.reload.name }.to('Anatoly')
  end

  it 'should edit user photo'
end
