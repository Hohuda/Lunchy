# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:admin) { create(:admin) }

  before(:each) do
    sign_in(admin)
  end

  before(:all) do
    @user = create(:user)
    @menu = create_menu_with_victuals
  end

  describe '#index' do
    it 'should return index page' do
      get orders_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:order) { create(:order, user: @user, menu: @menu) }

    it 'should return show page' do
      get order_path(order)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should return new order page' do
      get new_order_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    let(:order) { create(:order, user: @user, menu: @menu) }

    it 'should return edit page' do
      get edit_order_path(order)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:params) do
      { order: { user_id: @user.id, menu_id: @menu.id } }
    end

    subject { post orders_path, params: params }

    it 'should create new order' do
      expect { subject }.to change { Order.count }.by(1)
    end
  end

  describe '#update' do
    let(:order) { create(:order, user: @user, menu: @menu) }
    let(:params) do
      { id: order, order: { victual_ids: @menu.victual_ids } }
    end

    subject { patch order_path(order), params: params }

    it 'should change victuals' do
      expect { subject }.to change { order.victuals.count }.by(@menu.victuals.count)      
    end
  end

  describe '#destroy' do
    it 'should delete order' do
      order = create(:order, user: @user, menu: @menu)
      expect { delete order_path(order) }.to change { Order.count }.by(-1)
    end
  end
end
