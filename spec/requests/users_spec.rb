require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:admin) { create(:admin) }
  
  before(:each) do
    sign_in(admin)
  end

  describe '#index' do
  
    it 'should get index page' do
      get users_path(format: :json)
      expect(response.body).to have_http_status(:ok)
    end
  end

  describe '#show' do
    it 'should get show page' do
      get user_path(admin, format: :json)
      expect(response).to have_http_status(:ok)
    end
  end
end
