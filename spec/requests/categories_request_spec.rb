require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe '#index' do
    it 'should get index page if admin' do
      sign_in(admin)
      get categories_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect index page if user' do
      sign_in(user)
      get categories_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    let!(:category) { create(:category) }

    it 'should redirect to victuals index with params' do
      sign_in(user)
      get category_path(category)
      expect(response).to redirect_to(victuals_path(category_id: category.id))
    end
  end

  describe '#new' do
    it 'should get new path if admin' do
      sign_in(admin)
      get new_category_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect new page if user' do
      sign_in(user)
      get new_category_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#create' do
    let(:params) { { category: attributes_for(:category) } }
    subject { post categories_path, params: params }

    it 'should create new category if admin' do
      sign_in(admin)
      expect { subject }.to change { Category.count }.by(1)
    end

    it 'should redirect create action if user' do
      sign_in(user)
      subject
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#delete' do
    it 'should get delete_categories page if admin' do
      sign_in(admin)
      get delete_categories_path
      expect(response).to have_http_status(:ok)
    end

    it 'should redirect delete_categories page if user' do
      sign_in(user)
      get delete_categories_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#destroy' do
    it 'should delete categories by ids if admin' do
      sign_in(admin)
      categories = create_list(:category, 5)
      params = { category_delete: { category_ids: categories.take(2).map(&:id) } }
      expect { post destroy_chosen_categories_path, params: params }.to change { Category.count }.by(-2)
      expect(response).to redirect_to(categories_path)
    end

    it 'should redirect action if user' do
      sign_in(user)
      post destroy_chosen_categories_path
      expect(response).to redirect_to(root_path)
    end
  end
end
