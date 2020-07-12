require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:admin) { create(:admin) }

  before(:each) do
    sign_in(admin)
  end

  describe '#index' do
    it 'should get index path' do
      get categories_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:category) { create(:category) }

    it 'should get show path' do
      get category_path(category)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'should get new path' do
      get new_category_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    let(:params) { { category: attributes_for(:category) } }
    subject { post categories_path, params: params }

    it 'should create new category' do
      expect { subject }.to change { Category.count }.by(1)
    end
  end

  describe '#delete' do
    it 'should get delete categories path' do
      get delete_categories_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#destroy' do
    it 'should delete categories by ids' do
      categories = create_list(:category, 5)
      params = { category_delete: { category_ids: categories.take(2).map(&:id) } }
      expect { post destroy_chosen_categories_path, params: params }.to change { Category.count }.by(-2)
      expect(response).to redirect_to(categories_path)
    end
  end
end
