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
    fixtures :orders
    it 'should count total cost for orders relation' do
      total_income = Order.calculate_total_income
      expect(total_income).to eq(Order.sum('total_cost'))
    end

    it 'should return orders searched by today' do
      today = Date.today
      yesterday = today - 1.day
      orders = Order.search_by_date(today.to_s)
      today_orders = Order.where(created_at: today.beginning_of_day..today.end_of_day)
      yesterday_orders = Order.where(created_at: yesterday.beginning_of_day..yesterday.end_of_day)
      expect(orders).to match_array(today_orders)
      expect(orders).not_to match_array(yesterday_orders)
    end
  end

  describe 'instance methods' do
    fixtures :users
    let(:user) { users(:johny) }
    subject { Order.create(user_id: user.id) }
    it 'should submit order' do
      expect { subject.submit }.to change { subject.editable }.from(true).to(false)
    end

    it 'should habe editable?' do
      expect(subject.editable?).to eq(subject.editable)
    end
  end
end
