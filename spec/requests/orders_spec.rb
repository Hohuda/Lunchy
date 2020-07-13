# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  before(:all) do
    @user = create(:user)
    @menu = create_menu_with_victuals
  end

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
    let(:order) { create(:order, user: @user, menu: @menu) }

    it 'should get show page if admin' do
      sign_in(admin)
      get order_path(order)
      expect(response).to have_http_status(:ok)
    end

    context 'if user is not admin' do
      let(:own_order) { create(:order, user: user, menu: @menu) }

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
    let(:order) { create(:order, user: @user, menu: @menu) }

    it 'should get edit page if admin' do
      sign_in(admin)
      get edit_order_path(order)
      expect(response).to have_http_status(:ok)
    end

    context 'if user is not admin' do
      let(:own_order) { create(:order, user: user, menu: @menu) }

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
    let(:params) do
      { order: { user_id: @user.id, menu_id: @menu.id } }
    end

    subject { post orders_path, params: params }

    it 'should create new order if admin' do
      sign_in(admin)
      expect { subject }.to change { Order.count }.by(1)
    end

    context 'if user is not admin' do
      let(:own_order_params) do
        { order: {user_id: user.id, menu_id: @menu.id } }
      end

      before(:each) do
        sign_in(user)
      end

      it 'should create own order' do
        expect {
          post orders_path, params: own_order_params
        }.to change { Order.count }.by(1)
      end

      it 'should redirect action if try to create order for another user' do
        expect {
          post orders_path, params: params
        }.not_to change { Order.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#update' do
    let(:order) { create(:order, user: @user, menu: @menu) }
    let(:params) do
      { id: order, order: { victual_ids: @menu.victual_ids } }
    end

    subject { patch order_path(order), params: params }

    it 'should change victuals if admin' do
      sign_in(admin)
      expect { subject }.to change { order.victuals.count }.by(@menu.victuals.count)      
    end

    context 'if user is not admin' do
      let(:own_order) { create(:order, user: user, menu: @menu ) }
      let(:own_order_params) do
        { id: own_order, order: { victual_ids: @menu.victual_ids } }
      end

      before(:each) do
        sign_in(user)
      end

      it 'should update own order' do
        expect {
          patch order_path(own_order), params: own_order_params
        }.to change { own_order.victuals.count }.by(@menu.victuals.count)
      end

      it 'should redirect action if try to update another user order' do
        expect {
          patch order_path(order), params: params
        }.not_to change { order.victuals.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#destroy' do
    it 'should delete order if admin' do
      sign_in(admin)
      order = create(:order, user: @user, menu: @menu)
      expect { delete order_path(order) }.to change { Order.count }.by(-1)
    end

    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end

      it 'should delete own order' do
        own_order = create(:order, user: user, menu: @menu)
        expect { delete order_path(own_order) }.to change { Order.count }.by(-1)
      end

      it 'should redirect if try to delete another user order' do
        order = create(:order, user: @user, menu: @menu)
        expect { delete order_path(order) }.not_to change { Order.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
