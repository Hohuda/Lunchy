require 'rails_helper'

RSpec.describe "Victuals", type: :request do
  let(:admin) { create(:admin) }

  before(:each) do
    sign_in(admin)
  end

  describe '#index' do
    it 'should get index page' do
      get victuals_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:victual) { create(:victual) }
    it 'should get show page' do
      get victual_path(victual)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should get new victual page' do
      get new_victual_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    let(:victual) { create(:victual) }
    it 'should get edit victual page' do
      get edit_victual_path(victual)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:params) { { victual: attributes_for(:victual) } }

    subject { post victuals_path, params: params }

    it 'should create new victual' do
      expect { subject }.to change { Victual.count }.by(1)
    end
  end

  describe '#update' do
    let(:victual) { create(:victual) }
    let(:category_ids) { { category_ids: create_list(:category, 2).map(&:id) } }
    let(:avatar) { { avatar: nil } }
    let(:params) do
      { victual: attributes_for(:victual).merge(category_ids).merge(avatar) }
    end

    subject { patch victual_path(victual), params: params }

    it 'should update victual' do
      expect { subject }.to change { victual.reload.updated_at }
    end
  end

  describe '#destroy' do
    it 'should destroy victual' do
      victual = create(:victual)

      expect { delete victual_path(victual) }.to change { Victual.count }.by(-1)
      expect(response).to redirect_to(victuals_path)
    end
  end
end
