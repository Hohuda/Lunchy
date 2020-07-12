require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:admin) { create(:admin) }

  before(:each) do
    sign_in(admin)
  end

  describe '#home' do
    it 'should get home page that is root' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#contact' do
    it 'should get contact page' do
      get contact_path
      expect(response).to have_http_status(:ok)
    end
  end
end
