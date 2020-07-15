# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Victuals', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe '#index' do
    it 'should get index page if admin' do
      sign_in(admin)
      get victuals_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get index page if user' do
      sign_in(user)
      get victuals_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let!(:victual) { create(:victual) }

    it 'should get show page if admin' do
      sign_in(admin)
      get victual_path(victual)
      expect(response).to have_http_status(:ok)
    end

    it 'should get show page if user' do
      sign_in(user)
      get victual_path(victual)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should get new victual page if admin' do
      sign_in(admin)
      get new_victual_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect victual page if user' do
      sign_in(user)
      get new_victual_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#edit' do
    let!(:victual) { create(:victual) }

    it 'should get edit victual page if admin' do
      sign_in(admin)
      get edit_victual_path(victual)
      expect(response).to have_http_status(:ok)
    end
    
    it 'should redirect edit victual page if user' do
      sign_in(user)
      get edit_victual_path(victual)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#create' do
    let!(:params) { { victual: attributes_for(:victual) } }

    subject { post victuals_path, params: params }

    it 'should create new victual if admin' do
      sign_in(admin)
      expect { subject }.to change { Victual.count }.by(1)
    end

    it 'should redirect action if user' do
      sign_in(user)
      post victuals_path, params: params
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#update' do
    let!(:victual) { create(:victual) }
    let(:category_ids) { { category_ids: create_list(:category, 2).map(&:id) } }
    let(:avatar) { { avatar: nil } }
    let!(:params) do
      { victual: attributes_for(:victual).merge(category_ids).merge(avatar) }
    end

    subject { patch victual_path(victual), params: params }

    it 'should update victual if admin' do
      sign_in(admin)
      expect { subject }.to(change { victual.reload.updated_at })
    end

    it 'should redirect action if user' do
      sign_in(user)
      patch victual_path(victual), params: params
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#destroy' do
    let!(:victual) { create(:victual) }

    subject { delete victual_path(victual) }

    it 'should destroy victual if admin' do
      sign_in(admin)
      expect { subject }.to change { Victual.count }.by(-1)
      expect(response).to redirect_to(victuals_path)
    end

    it 'should redirect action if user' do
      sign_in(user)
      delete victual_path(victual)
      expect(response).to redirect_to(root_path)
    end
  end
end
