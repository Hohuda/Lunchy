require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should have_many(:orders).class_name('Order') }
    it { should have_many(:menu_items).class_name('MenuItem') }
    it { should have_many(:victuals).class_name('Victual') }
    it { should have_many(:categories).class_name('Category') }
  end

  describe 'db columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_index(:created_at) }
  end

  describe 'scopes' do
    it 'should return today menus' do
      today_menu = Menu.create(name: 'for today')
      yest_menu = Menu.create(name: 'for yesterday', created_at: Time.zone.now - 1.day)
      expect(Menu.today_menus).to include(today_menu)
      expect(Menu.today_menus).not_to include(yest_menu)
    end

    it 'should be ordered newest first' do
      menu = Menu.create
      expect(Menu.first).to eq(menu)
    end
  end

  describe 'victuals' do
    it 'should set victuals by ids' do
      User.create name: 'name', email: 'email@email.com', password: 'password'
    end
  end
end
