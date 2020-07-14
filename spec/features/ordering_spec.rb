# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Ordering', type: :feature do
  before(:each) do
    @admin = create(:admin)
    @user = create(:user)
    @menu = create_menu_with_victuals
    @victual_names = @menu.victuals.map(&:name)
  end

  it 'should create order from today_menus page' do
    sign_in(@user)

    visit root_path

    click_link('Menus')
    click_link('Details')

    @victual_names.each do |name|
      expect(page).to have_content(name)
    end

    click_link('Create order')
    expect(page).to have_content('Order #')
  end

  it 'should create order from user profile page' do
    sign_in(@user)

    visit user_path(@user)
    click_link('Make new order')

    expect(page).to have_content('Menus')
    choose(@menu.name)
    click_button('Create')

    expect(page).to have_content('Order #')
  end

  it 'should edit order' do
    sign_in(@user)

    create(:order, user: @user, menu: @menu)

    visit root_path
    click_link('Orders')
    click_link('Details')
    click_link('Add order items')

    @victual_names.each do |name|
      expect(page).to have_content(name)
      check(name)
    end

    click_button('Change Items')

    @victual_names.each do |name|
      expect(page).to have_content(name)
    end

    expect(page).not_to have_link('Add order items')
    expect(page).to have_link('Edit order')
  end

  it 'should submit order' do
    sign_in(@user)

    order = create(:order, user: @user, menu: @menu)

    visit order_path(order)
    expect(page).to have_link('Add order items')
    expect {
      click_link('Submit order') 
    }.not_to(change { order.reload.editable })

    click_link('Add order items')
    check(@victual_names.first)
    click_button('Change Items')

    expect do
      click_link('Submit order')
    end.to change {
      order.reload.editable
    }.to(false)

    expect(page).not_to have_link('Delete order')
    expect(page).not_to have_link('Submit order')
    expect(page).to have_content('In Delivery')
  end

  it 'should delete order' do
    sign_in(@user)

    order = create(:order, user: @user, menu: @menu)

    visit order_path(order)
    expect { click_link('Delete order') }.to(change { Order.count })
  end
end
