require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:menu_item) }

    before(:context) do
      menu = create(:menu)
      victual = create(:victual)
      menu.victuals << victual
      @user = create(:user)
    end

    context 'when try to destroy parent model' do
      before(:each) do
        @order = create(:order, user: @user)
        @menu_item = MenuItem.take
        @order.menu_items << @menu_item
      end

      it 'should depend on Order destroying' do
        expect { @order.destroy }.to change { OrderItem.count }.by(-1)
      end

      it 'should depend on MenuItem destroying' do
        expect { @menu_item.destroy }.to change { OrderItem.count }.by(-1)
      end
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
