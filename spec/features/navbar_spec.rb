require 'rails_helper'

RSpec.feature "Navbars", type: :feature do
  context 'unauthorized navbar' do
    it 'should have base links' do
      link_names = [
        'Lunchy',
        'Home',
        'Log in'
      ]
      visit root_path

      link_names.each do |link_name|
        expect(page).to have_link(link_name)
      end
    end
  end

  context 'authorized navbar' do
    it 'should have admins links if admin' do
      admin = create(:admin)
      sign_in(admin)

      link_names = [
        'Users',
        'Categories',
        'Victuals'
      ]
      visit root_path

      link_names.each do |link_name|
        expect(page).to have_link(link_name)
      end
    end

    it 'should have users links if user' do
      user = create(:user)
      sign_in(user)

      link_names = [
        'Lunchy',
        'Home',
        'Menus',
        'Orders',
        user.name,
        'Profile',
        'Edit',
        'Log out',
        'Contact'
      ]
      visit root_path

      link_names.each do |link_name|
        expect(page).to have_link(link_name)
      end
    end
  end
end
