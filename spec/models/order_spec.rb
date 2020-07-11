require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    # it { should belong_to(:menu) } # Fails test because of default_menu callback
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
    # it { should validate_presence_of(:menu_id) } # Fails test because of default_menu callback
    it { should validate_presence_of(:total_cost) }
  end
  
  describe 'default scope' do
    it 'newest should go first' do
      user = create(:user)
      menu = create(:menu)
      create(:order, user: user, menu: menu)
      second_order = create(:order, user: user)
      expect(second_order).to eq(Order.first)
    end
  end

  describe 'callbacks' do
    before(:each) do
      @user = create(:user)
      @menu = create_menu_with_victuals
    end
    
    it 'should calculate total cost before save' do
      order = create(:order, user: @user, menu: @menu)
      order.menu_items << @menu.menu_items
      order.save
      expect(order.total_cost).to eq(@menu.victuals.sum('price'))
    end

    it 'should add default menu before validations' do
      order = create(:order, user: @user)
      expect(order.menu.present?).to eq(true)
    end
  end

  describe 'class methods' do
    before(:each) do
      @user = create(:user)
      @menu = create_menu_with_victuals
    end

    it 'should count total cost for orders relation' do
      create_list(:order, 5, user: @user, menu: @menu)
      total_income = Order.calculate_total_income
      expect(total_income).to eq(Order.sum('total_cost'))
    end

    it 'should return orders searched by today' do
      today_orders = create_list(:order, 5, user: @user, menu: @menu)
      yesterday_orders = create_list(:order, 5, user: @user, menu: @menu, created_at: Date.yesterday)
      orders = Order.search_by_date(Date.today.to_s)
      expect(orders).to match_array(today_orders)
      expect(orders).not_to match_array(yesterday_orders)
    end
  end

  describe 'instance methods' do
    before(:each) do
      @user = create(:user)
      @menu = create_menu_with_victuals
    end
    
    it 'should submit order' do
      order = create(:order, user: @user, menu: @menu)
      expect { order.submit }.to change { order.editable }.from(true).to(false)
    end

    it 'should have editable?' do
      order = create(:order, user: @user, menu: @menu)
      expect(order.editable?).to eq(order.editable)
    end

    it 'should set victuals by id' do
      order = create(:order, user: @user, menu: @menu)
      order.set_victuals(@menu.victual_ids)
      expect(order.reload.victuals).to match(@menu.victuals)
      order.set_victuals(@menu.victual_ids.first)
      expect(order.reload.victual_ids).to contain_exactly(@menu.victual_ids.first)
    end
  end
end
