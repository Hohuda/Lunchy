require 'rails_helper'

RSpec.feature "OrderDateSearches", type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let(:menu) { create(:menu) }
  let!(:today_order) { create(:order, user: user, menu: menu) }
  let!(:week_ago_order) { create(:order, user: user, menu: menu, created_at: (Date.today - 7.days)) }

  before(:each) do
    sign_in(admin)
  end

  it 'should search for today orders' do
    visit orders_path

    fill_in 'search[order_date]', with: Date.today.to_s
    click_button('Search')

    expect(page).to have_content("Order ##{today_order.id}")
    expect(page).not_to have_content("Order ##{week_ago_order.id}")
  end

  it 'should search for week ago orders' do
    visit orders_path

    fill_in 'search[order_date]', with: (Date.today - 7.days).to_s
    click_button('Search')

    expect(page).to have_content("Order ##{week_ago_order.id}")
    expect(page).not_to have_content("Order ##{today_order.id}")
  end
end
