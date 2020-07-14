# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menus', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe '#index' do
    it 'should get index page if admin' do
      sign_in(admin)
      get menus_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect index page if user' do
      sign_in(user)
      get menus_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    let(:menu) { create(:menu) }

    it 'should get show page if admin' do
      sign_in(admin)
      get menu_path(menu)
      expect(response).to have_http_status(:ok)
    end

    it 'should get show page if user' do
      sign_in(user)
      get menu_path(menu)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should get new menu page if admin' do
      sign_in(admin)
      get new_menu_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect new menu page if' do
      sign_in(user)
      get new_menu_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#edit' do
    let(:menu) { create(:menu) }

    it 'should get edit menu page if admin' do
      sign_in(admin)
      get edit_menu_path(menu)
      expect(response).to have_http_status(:ok)
    end

    it 'should get edit menu page if user' do
      sign_in(user)
      get edit_menu_path(menu)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#create' do
    let(:params) { { menu: attributes_for(:menu) } }

    subject { post menus_path, params: params }

    it 'should create new menu if admin' do
      sign_in(admin)
      expect { subject }.to change { Menu.count }.by(1)
    end

    it 'should redirect action if user' do
      sign_in(user)
      subject
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#update' do
    let(:menu) { create(:menu) }
    let(:victual_ids) { { victual_ids: create_list(:victual, 5).map(&:id) } }
    let(:params) { { menu: attributes_for(:menu).merge(victual_ids) } }

    subject { patch menu_path(menu), params: params }

    it 'should update menu if admin' do
      sign_in(admin)
      expect { subject }.to(change { menu.reload.updated_at })
    end

    it 'should redirect action if user' do
      sign_in(user)
      subject
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#destroy' do
    it 'should delete menu if admin' do
      menu = create(:menu)

      sign_in(admin)
      expect { delete menu_path(menu) }.to change { Menu.count }.by(-1)
    end

    it 'should redirect actiono if user' do
      menu = create(:menu)

      sign_in(user)
      delete menu_path(menu)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#today' do
    it 'should get today menus page if admin' do
      sign_in(admin)
      get today_menus_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get today menus page if user' do
      sign_in(user)
      get today_menus_path
      expect(response).to have_http_status(:ok)
    end
  end
end
