require 'rails_helper'

RSpec.describe OrderPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:menu) { create(:menu) }
  let(:user_order) { create(:order, user: user, menu: menu) }
  let(:admin_order) { create(:order, user: admin, menu: menu) }

  subject { described_class }

  %i[index? today? for_day?].each do |policy|
    permissions policy do
      it 'should be accessible only for admin' do
        expect(subject).not_to permit(user)
        expect(subject).to permit(admin)
      end
    end
  end

  policies = %i[show? create? update? destroy? new? edit? submit?]

  policies.each do |policy|
    permissions policy do
      context 'if user is not admin' do
        it 'denies access to other users orders' do
          expect(subject).not_to permit(user, admin_order)
        end

        it 'grants access to own orders' do
          expect(subject).to permit(user, user_order)
        end
      end

      context 'if user is admin' do
        it 'grants access to any order' do
          expect(subject).to permit(admin, user_order)
          expect(subject).to permit(admin, admin_order)
        end
      end
    end
  end
end
