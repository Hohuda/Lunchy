# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryItem, type: :model do
  describe 'associations' do
    it { should belong_to(:victual) }
    it { should belong_to(:category) }

    context 'when try to destroy parent model' do
      let(:victual) { create(:victual) }
      let(:category) { create(:category) }

      before(:each) do
        victual.categories << category
      end

      it 'should depend on Victual destroying' do
        expect { victual.destroy }.to change { CategoryItem.count }.by(-1)
      end

      it 'should depend on Category destroying' do
        expect { category.destroy }.to change { CategoryItem.count }.by(-1)
      end
    end
  end

  describe 'db columns' do
    it { should have_db_column(:victual_id).of_type(:integer) }
    it { should have_db_column(:category_id).of_type(:integer) }
    it { should have_db_index(:victual_id) }
    it { should have_db_index(:category_id) }
    it { should have_db_index(%i[victual_id category_id]).unique }
  end

  describe 'validations' do
    it { should validate_presence_of(:victual_id) }
    it { should validate_presence_of(:category_id) }
    it { should validate_uniqueness_of(:category_id).scoped_to(:victual_id) }
  end
end
