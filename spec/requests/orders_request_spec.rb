# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let(:menu) { create_menu_with_victuals }

  describe '#index' do
    it 'should get index page if admin' do
      sign_in(admin)
      get orders_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect index page if user' do
      sign_in(user)
      get orders_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    let(:order) { create(:order, user: admin, menu: menu) }

    it 'should get show page if admin' do
      sign_in(admin)
      get order_path(order)
      expect(response).to have_http_status(:ok)
    end

    context 'if user is not admin' do
      let(:own_order) { create(:order, user: user, menu: menu) }

      before(:each) do
        sign_in(user)
      end

      it 'should get own order show page' do
        get order_path(own_order)
        expect(response).to have_http_status(:ok)
      end

      it 'should redirect another user order show page' do
        get order_path(order)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#new' do
    it 'should get new order page if admin' do
      sign_in(admin)
      get new_order_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get new order page if user' do
      sign_in(user)
      get new_order_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    let(:order) { create(:order, user: admin, menu: menu) }

    it 'should get edit page if admin' do
      sign_in(admin)
      get edit_order_path(order)
      expect(response).to have_http_status(:ok)
    end

    context 'if user is not admin' do
      let(:own_order) { create(:order, user: user, menu: menu) }

      before(:each) do
        sign_in(user)
      end

      it 'should get own order edit page' do
        get edit_order_path(own_order)
        expect(response).to have_http_status(:ok)
      end

      it 'should redirect another user order edit page' do
        get edit_order_path(order)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#create' do
    let(:admin_order_params) do
      { order: { user_id: admin.id, menu_id: menu.id } }
    end

    let(:user_order_params) do
      { order: { user_id: user.id, menu_id: menu.id } }
    end

    context 'if user is admin' do
      before(:each) do
        sign_in(admin)
      end

      it 'should create own new order' do
        expect {
          post orders_path, params: admin_order_params
        }.to change { Order.count }.by(1)
      end

      it 'should create new order for another user' do
        expect {
          post orders_path, params: user_order_params
        }.to change { Order.count }.by(1)
      end
    end
    
    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end
      
      it 'should create new own order' do
        expect {
          post orders_path, params: user_order_params
        }.to change { Order.count }.by(1)
      end

      it 'should redirect action if try to create order for another user' do
        expect {
          post orders_path, params: admin_order_params
        }.not_to(change { Order.count })
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#update' do
    let(:admin_order) { create(:order, user: admin, menu: menu) }
    let(:user_order) { create(:order, user: user, menu: menu ) }

    let(:admin_order_params) do
      { id: admin_order, order: { victual_ids: menu.victual_ids } }
    end

    let(:user_order_params) do
      { id: user_order, order: { victual_ids: menu.victual_ids } }
    end

    context 'if user is admin' do
      before(:each) do
        sign_in(admin)
      end

      it 'should update own order' do
        expect {
          patch order_path(admin_order), params: admin_order_params
        }.to change { admin_order.victuals.count }.by(menu.victuals.count)
      end

      it 'should update another user order' do
        expect {
          patch order_path(user_order), params: user_order_params
        }.to change { user_order.victuals.count }.by(menu.victuals.count)
      end
    end

    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end

      it 'should update own order' do
        expect {
          patch order_path(user_order), params: user_order_params
        }.to change { user_order.victuals.count }.by(menu.victuals.count)
      end

      it 'should redirect action if try to update another user order' do
        expect {
          patch order_path(admin_order), params: admin_order_params
        }.not_to(change { admin_order })
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#destroy' do
    let!(:admin_order) { create(:order, user: admin, menu: menu) }
    let!(:user_order) { create(:order, user: user, menu:menu) }

    context 'if user is admin' do
      before(:each) do
        sign_in(admin)
      end
      
      it 'should delete own order' do
        expect {
          delete order_path(admin_order)
        }.to change { Order.count }.by(-1)
      end

      it 'should delete order of another user' do
        expect {
          delete order_path(user_order)
        }.to change { Order.count }.by(-1)
      end
    end

    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end

      it 'should delete own order' do
        expect {
          delete order_path(user_order)
        }.to change { Order.count }.by(-1)
      end

      it 'should redirect if try to delete another user order' do
        expect {
          delete order_path(admin_order)
        }.not_to(change { Order.count })
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#submit' do
    let(:admin_order) { create(:order, user: admin, menu: menu) }
    let(:user_order) { create(:order, user: user, menu: menu) }

    context 'if user is admin' do
      before(:each) do
        sign_in(admin)
      end

      it 'should submit own order' do
        expect {
          get submit_order_path(admin_order)
        }.to change { admin_order.reload.editable }.to(false)
      end

      it 'should submit another user order' do
        expect {
          get submit_order_path(user_order)
        }.to change { user_order.reload.editable }.to(false)
      end
    end

    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end

      it 'should submit own order' do
        expect {
          get submit_order_path(user_order)
        }.to change { user_order.reload.editable }.to(false)
      end

      it 'should redirect if try to sumbit another user order' do
        expect {
          get submit_order_path(admin_order)
        }.not_to(change { admin_order })
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#today' do
    let(:order) { create(:order, user: user, menu: menu) }

    it 'should return orders for today if admin' do
      sign_in(admin)
      get today_orders_path
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root if user' do
      sign_in(user)
      get today_orders_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#for_day' do
    let!(:order) { create(:order, user: user, menu: menu, created_at: Date.yesterday) }
    let(:params) { { search: { order_date: Date.yesterday.to_s } } }

    it 'should search orders by date if admin' do
      sign_in(admin)
      get for_day_orders_path, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root if user' do
      sign_in(user)
      get for_day_orders_path, params: params
      expect(response).to redirect_to(root_path)
    end
  end
end
