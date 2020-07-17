require 'rails_helper'

RSpec.feature "MenuDateSearches", type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:today_menu) { create(:menu, created_at: Date.today) }
  let!(:week_ago_menu) { create(:menu, created_at: Date.today - 7.days) }

  before do
    sign_in(user)
  end

  it 'should search for today menus' do
    visit user_path(user)

    fill_in "search[menu_date]", with: Date.today.to_s
    click_button('Search for menus')
    expect(page).to have_content(today_menu.name)
    expect(page).not_to have_content(week_ago_menu.name)
  end


  it 'should search for week ago menu' do
    visit user_path(user)

    fill_in "search[menu_date]", with: (Date.today - 7.days).to_s
    click_button('Search for menus')
    expect(page).to have_content(week_ago_menu.name)
    expect(page).not_to have_content(today_menu.name)
  end
end
