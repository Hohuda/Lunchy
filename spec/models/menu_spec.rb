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
      today_menu = create(:menu)
      yesterday_menu = create(:menu, created_at: Date.yesterday)
      expect(Menu.today_menus).to include(today_menu)
      expect(Menu.today_menus).not_to include(yesterday_menu)
    end

    it 'should be ordered newest first' do
      menu = Menu.create
      expect(Menu.first).to eq(menu)
    end
  end

  describe 'victuals' do
    let(:ids) { create_list(:victual, 5).map(&:id) }
    
    it 'should set victuals by ids' do
      menu = Menu.create
      menu.set_victuals(ids)
      expect(menu.victual_ids).to match(ids)
      menu.set_victuals(ids.first)
      expect(menu.victual_ids).to contain_exactly(ids.first)
    end
  end

  describe 'class methods' do
    it 'should return menus searched by today' do
      today_menus = create_list(:menu, 3)
      yesterday_menus = create_list(:menu, 3, created_at: Date.yesterday)
      expect(Menu.today_menus).to match_array(today_menus)
      expect(Menu.today_menus).not_to match_array(yesterday_menus)
    end
  end
end
