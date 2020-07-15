require 'rails_helper'

# Here are a lot of quesitons how to test devise user ?????????
RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
  end

  describe 'db columns' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:company) }
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:admin).of_type(:boolean).with_options(null: false, default: false) }
    it { should have_db_column(:avatar).of_type(:string) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it {
      create(:user)
      should validate_uniqueness_of(:name)
    }
  end

  describe 'admin' do
    it 'should give admin to first created user'
  end
end