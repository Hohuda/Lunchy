require 'rails_helper'

RSpec.describe "Menus", type: :request do
  let(:admin) { create(:admin) }

  before(:each) do
    sign_in(admin)
  end

  describe '#index' do
    it 'should return index page' do
      get menus_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:menu) { create(:menu) }

    it 'should return show page' do
      get menu_path(menu)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should return new menu page' do
      get new_menu_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    let(:menu) { create(:menu) }

    it 'should return edit page' do
      get edit_menu_path(menu)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:params) { { menu: attributes_for(:menu) } }

    subject { post menus_path, params: params }

    it 'should create new menu' do
      expect { subject }.to change { Menu.count }.by(1)
    end
  end

  describe '#update' do
    let(:menu) { create(:menu) }
    let(:victual_ids) { { victual_ids: create_list(:victual, 5).map(&:id) } }
    let(:params) { { menu: attributes_for(:menu).merge(victual_ids) } }

    subject { patch menu_path(menu), params: params }

    it 'should update menu' do
      expect { subject }.to change { menu.reload.updated_at } 
    end
  end

  describe '#destroy' do
    it 'should delete menu' do
      menu = create(:menu)
      expect { delete menu_path(menu) }.to change { Menu.count }.by(-1)
    end
  end
end
