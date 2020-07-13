require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe '#home root' do
    it 'should get home page if admin' do
      sign_in(admin)
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get home page if user' do
      sign_in(user)
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get home page if not authorized' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#contact' do
    it 'should get home page if admin' do
      sign_in(admin)
      get contact_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get home page if user' do
      sign_in(user)
      get contact_path
      expect(response).to have_http_status(:ok)
    end

    it 'should get home page if not authorized' do
      get contact_path
      expect(response).to have_http_status(:ok)
    end
  end
end
