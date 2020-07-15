require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  subject { described_class }

  permissions :index? do
    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user, user)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, admin)
    end
  end

  %i[show? orders?].each do |policy|
    permissions policy do
      context 'if user is not admin' do
        it 'denies access to another user show page' do
          expect(subject).not_to permit(user, admin)
        end
  
        it 'grants access to own show page' do
          expect(subject).to permit(user, user)
        end
      end
  
      context 'if user is admin' do
        it 'grants access to any user show page' do
          expect(subject).to permit(admin, user)
          expect(subject).to permit(admin, admin)
        end
      end
    end
  end
end
