require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  

  describe '#index' do
    it 'should get index page as admin' do
      sign_in(admin)
      get users_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get index page as user' do
      sign_in(user)
      get users_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    it 'should get any user show page as admin' do
      sign_in(admin)
      get user_path(admin)
      expect(response).to have_http_status(:ok)
      get user_path(user)
      expect(response).to have_http_status(:ok)
    end

    context 'when user is not admin' do
      before(:each) do
        sign_in(user)
      end

      it 'should get own show page' do
        get user_path(user)
        expect(response).to have_http_status(:ok)
      end

      it 'should not get other users show pages' do
        get user_path(admin)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#orders' do
    it 'should get any user orders page as admin' do
      sign_in(admin)

      get orders_for_user_path(admin)
      expect(response).to have_http_status(:ok)

      get orders_for_user_path(user)
      expect(response).to have_http_status(:ok)
    end

    context 'if user is not admin' do
      before(:each) do
        sign_in(user)
      end
      
      it 'should get own orders page' do
        get orders_for_user_path(user)
        expect(response).to have_http_status(:ok)
      end

      it 'redirects when try to get another user orders page' do
        get orders_for_user_path(admin)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
