require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:menu) }
    it { should have_many(:order_items) }
    it { should have_many(:menu_items) }
    it { should have_many(:victuals) }
  end

  describe 'db columns' do
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:menu_id).of_type(:integer) }
    it { should have_db_column(:total_cost).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { should have_db_column(:editable).of_type(:boolean).with_options(null: false, default: true) }
    it { should have_db_index(:menu_id) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:created_at) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:menu_id) }
    it { should validate_presence_of(:total_cost) }
  end
  
  describe 'scope' do
    context 'default scope in descending order by created_at' do
      it 'newest should go first' do
        user = User.take
        menu = Menu.create(name: 'menu')
        order = Order.create(user_id: user.id, menu_id: menu.id)
        expect(order).to eq(Order.first)
      end
    end
  end

  describe 'callbacks' do
    before(:example) do 
      @user = User.take
      @menu = Menu.create(name: 'menu')
      @order = Order.create(user_id: @user.id, menu_id: @menu.id)
    end

    it 'should calculate total cost before save' do
      @order.menu_items << @menu.menu_items
      expect(@order.total_cost).to eq(@menu.victuals.sum('price'))
    end

    it 'should add default menu before validations' do
      order = Order.create(user_id: @user.id)
      expect(order.menu.present?).to eq(true)
    end
  end

  describe 'class methods' do
    it 'should count total cost for orders relation'
  end
    
end
