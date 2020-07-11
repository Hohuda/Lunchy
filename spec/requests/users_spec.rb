require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    context 'when current user is admin' do
      let(:admin) { create(:admin) }

      before(:each) do
        sign_in admin
      end

      it 'should have a current user' do
        expect(subject.current_user).to_not eq(nil)
      end

      it 'should return paginated users' do
        get users_path
        expect(response.body).to include(data)
        expect(response).to have_http_status(:ok)
      end
    end
  
    context 'when ordinary user authenticated' do
      let(:user) { create(:user) }
      
      before(:each) do
        sign_in user
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not authenticated' do
      it 'should redirect to log in page' do
        expect(response).to redirect_to(new_user_session_path)
        expect(response).to have_http_status(:load)
      end
    end
  end
end
