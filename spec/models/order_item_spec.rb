require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    fixtures :orders, :menu_items

    it { should belong_to(:order) }
    it { should belong_to(:menu_item) }

    it 'should be destroyed when parent order destroyed' do
      order = orders(:first_order)
      order.order_items.create(menu_item: menu_items(:drink_today_menu_item))
      expect { order.destroy }.to change { OrderItem.count }.by(-1)
    end
  end

  describe 'db columns' do
    it { should have_db_column(:order_id).of_type(:integer) }
    it { should have_db_column(:menu_item_id).of_type(:integer) }
    it { should have_db_column(:quantity).of_type(:integer) }
    it { should have_db_index(:order_id) }
    it { should have_db_index(:menu_item_id) }
    it { should have_db_index([:order_id, :menu_item_id]).unique }
  end

  describe 'validations' do
    it { should validate_presence_of(:order_id) }
    it { should validate_presence_of(:menu_item_id) }
    it { should validate_uniqueness_of(:order_id).scoped_to(:menu_item_id) }
  end
end
